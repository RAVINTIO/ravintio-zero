#!/usr/bin/env bash
# Tests for feature 0000558-plan-only-push-short-ci, req-001 and req-002: the workflow cancels a
# superseded pull request run, never cancels a push run, and gains no path filter.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WORKFLOW="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)/.github/workflows/ravintio.yml"

if [ ! -f "$WORKFLOW" ]; then
  echo "  SKIP: no repo workflow next to ravintio-zero/, so this is a consumer copy"
  print_summary
  exit 0
fi

# The top-level block runs from "concurrency:" to the next top-level key.
BLOCK="$(awk '/^concurrency:/{f=1; print; next} f && /^[a-z]/{exit} f{print}' "$WORKFLOW")"
JOBS_LINE="$(grep -n '^jobs:' "$WORKFLOW" | cut -d: -f1)"
BLOCK_LINE="$(grep -n '^concurrency:' "$WORKFLOW" | cut -d: -f1)"

# REQ-001 AC-1: a pull request event cancels the older run.
assert_contains "cancel-in-progress: \${{ github.event_name == 'pull_request' }}" "$BLOCK" "REQ-001 AC-1: only a pull_request event cancels an older run"
assert_equals "1" "$(grep -c '^concurrency:' "$WORKFLOW" || true)" "REQ-001 AC-1: one top-level concurrency block"
[ -n "$BLOCK_LINE" ] && [ -n "$JOBS_LINE" ] && [ "$BLOCK_LINE" -lt "$JOBS_LINE" ]
assert_equals "0" "$?" "REQ-001 AC-1: the block sits before jobs"

# REQ-001 AC-2: a push run never shares a group, so it is never cancelled.
assert_contains "github.event.pull_request.number" "$BLOCK" "REQ-001 AC-2: the group holds the pull request number"
assert_contains "github.sha" "$BLOCK" "REQ-001 AC-2: a push run gets a group of its own through the commit"
assert_not_contains "github.ref" "$BLOCK" "REQ-001 AC-2: no push group keys on a branch ref"

# REQ-001 AC-3: a closed event has a group of its own.
assert_contains "github.event.action == 'closed'" "$BLOCK" "REQ-001 AC-3: the group holds the closed flag"

# NFR-001: the group reads no user-controlled text.
assert_not_contains "head_ref" "$BLOCK" "NFR-001: the group reads no head ref text"
assert_not_contains "title" "$BLOCK" "NFR-001: the group reads no pull request title"

# REQ-002 AC-1: no path filter anywhere.
assert_equals "0" "$(grep -cE '^\s*paths(-ignore)?:' "$WORKFLOW" || true)" "REQ-002 AC-1: no paths or paths-ignore filter"

# REQ-002 AC-2: the shard jobs keep an event guard and name no file condition.
for j in bash-suites-shard windows-powershell-shard bash-suites windows-powershell; do
  IF="$(awk -v k="  $j:" '$0 == k {f=1; next} f && /^  [a-z][a-z-]*:/{exit} f && /^    if:/{print}' "$WORKFLOW")"
  assert_contains "github.event_name == 'pull_request'" "$IF" "REQ-002 AC-2: $j keeps its pull_request guard"
  assert_not_contains "changed" "$IF" "REQ-002 AC-2: $j has no changed-file condition"
done

print_summary
