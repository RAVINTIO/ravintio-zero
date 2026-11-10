#!/usr/bin/env bash
# Tests for feature 0000397-pack-source-in-src, req-003.
#
# The repo workflows run pack scripts and tests from src/ravintio-zero/. The
# consumer template keeps ravintio-zero/ paths.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REPO="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"
WFDIR="$REPO/.github/workflows"

if [ ! -d "$WFDIR" ]; then
  echo "  SKIP: no repo workflows, so this is a consumer copy"
  print_summary
  exit 0
fi

BAD="$(grep -nE '(node|bash|&) +(\./)?ravintio-zero/(scripts|tests)' "$WFDIR"/*.yml || true)"
assert_equals "" "$BAD" "AC-3: no workflow step runs pack scripts or tests from ravintio-zero/"
BAD2="$(grep -nE '^[^#]*[^/]ravintio-zero/tests' "$WFDIR"/*.yml | grep -v 'src/ravintio-zero/tests' || true)"
assert_equals "" "$BAD2" "AC-3: no workflow names ravintio-zero/tests outside src/"

assert_contains "node src/ravintio-zero/scripts/sync-installed.mjs --check" "$(cat "$WFDIR/ravintio.yml")" \
  "AC-3: the parity step exists"
assert_contains "bash src/ravintio-zero/tests/run-tests.sh" "$(cat "$WFDIR/ravintio.yml")" \
  "AC-3: the Bash suites run from the source"
assert_contains "src/ravintio-zero/tests/run-tests.ps1" "$(cat "$WFDIR/ravintio.yml")" \
  "AC-3: the PowerShell suites run from the source"

TPL="$(cat "$SCRIPT_DIR/../hooks/ravintio.yml")"
assert_contains "node ravintio-zero/scripts/" "$TPL" "the consumer template keeps ravintio-zero/ paths"
assert_not_contains "src/ravintio-zero" "$TPL" "the consumer template holds no src/ path"

print_summary
