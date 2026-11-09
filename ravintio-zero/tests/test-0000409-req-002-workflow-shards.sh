#!/usr/bin/env bash
# Tests for feature 0000409-ci-shards, req-002: CI runs the suites in parallel shards behind summary
# jobs that keep the required check names, and no Windows job runs pwsh.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WORKFLOW="$SCRIPT_DIR/../../.github/workflows/ravintio.yml"

if [ ! -f "$WORKFLOW" ]; then
  echo "  SKIP: no repo workflow next to ravintio-zero/, so this is a consumer copy"
  print_summary
  exit 0
fi

job() { awk -v k="  $1:" '$0 == k {f=1; print; next} f && /^  [a-z][a-z-]*:/{exit} f{print}' "$WORKFLOW"; }

BASH_SHARD="$(job bash-suites-shard)"
WIN_SHARD="$(job windows-powershell-shard)"
BASH_SUM="$(job bash-suites)"
WIN_SUM="$(job windows-powershell)"

# AC-1: shard jobs.
assert_contains "shard: [1, 2, 3, 4]" "$BASH_SHARD" "REQ-002 AC-1: bash runs 4 shards"
assert_contains 'RAVINTIO_SHARD: ${{ matrix.shard }}/4' "$BASH_SHARD" "REQ-002 AC-1: each bash shard sets its shard of 4"
assert_contains "shard: [1, 2, 3]" "$WIN_SHARD" "REQ-002 AC-1: Windows runs 3 shards"
assert_contains 'RAVINTIO_SHARD: ${{ matrix.shard }}/3' "$WIN_SHARD" "REQ-002 AC-1: each Windows shard sets its shard of 3"
for j in "$BASH_SHARD" "$WIN_SHARD"; do
  assert_contains "fail-fast: false" "$j" "REQ-002 AC-1: one failing shard does not cancel the others"
  assert_contains "contents: read" "$j" "REQ-002 AC-1: the shard job has read-only contents"
  assert_contains "persist-credentials: false" "$j" "REQ-002 AC-1: the shard checkout leaves no token"
done
assert_equals "0" "$(grep -c 'shell: pwsh' "$WORKFLOW" || true)" "REQ-002 AC-1: no Windows job runs pwsh"

# AC-2: summary jobs keep the required names and fail unless every shard passed.
assert_contains "name: windows-powershell (powershell)" "$WIN_SUM" "REQ-002 AC-2: the Windows summary job carries the required name"
assert_equals "0" "$(printf '%s\n' "$BASH_SUM" | grep -c '^    name:' || true)" "REQ-002 AC-2: the bash summary job reports under its key, bash-suites"
assert_contains "needs: windows-powershell-shard" "$WIN_SUM" "REQ-002 AC-2: the Windows summary job needs its shards"
assert_contains "needs: bash-suites-shard" "$BASH_SUM" "REQ-002 AC-2: the bash summary job needs its shards"
for j in "$BASH_SUM" "$WIN_SUM"; do
  assert_contains "if: always() && github.event_name == 'pull_request'" "$j" "REQ-002 AC-2: the summary job runs when a shard fails"
  assert_contains 'test "$RESULT" = success' "$j" "REQ-002 AC-2: the summary job fails unless the shards succeeded"
  assert_contains "permissions: {}" "$j" "REQ-002 AC-2: the summary job has no permissions"
  assert_equals "0" "$(printf '%s\n' "$j" | grep -c 'actions/checkout' || true)" "REQ-002 AC-2: the summary job checks out nothing"
done

print_summary
