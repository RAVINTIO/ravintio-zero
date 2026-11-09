#!/usr/bin/env bash
# Tests for feature 0000314-step-logs-stay-in-place, req-003: a suite run
# keeps every step log in plan/.initiative-logs/.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOGS="$REPO_ROOT/plan/.initiative-logs"

# Size and name of every file in the live log folder.
listing() { if [ -d "$LOGS" ]; then (cd "$LOGS" && find . -type f -exec ls -ln {} + | awk '{print $5, $9}' | sort -k2); fi; }

echo "=== req-003 AC-1: the guard suites leave the folder unchanged ==="
BEFORE="$(listing)"
bash "$SCRIPT_DIR/test-0000042-req-006-phase-guard-and-stale-cites.sh" >/dev/null 2>&1
bash "$SCRIPT_DIR/test-0000043-req-009-roadmap-resume-and-prefixes.sh" >/dev/null 2>&1
AFTER="$(listing)"
assert_equals "$BEFORE" "$AFTER" "req-003 AC-1: the step log listing is the same after the guard suites"

echo ""
echo "=== req-003 AC-2: no test moves the live folder ==="
# A command that moves, renames, or deletes the live repo's step log folder.
PATTERN='(mv|rm|rmdir)[^|;&]*(REPO_ROOT|ZERO_DIR)[^|;&]*\.initiative-logs|(mv|rm|rmdir)[^|;&]*\$LOGS'
HITS="$(grep -nE "$PATTERN" "$SCRIPT_DIR"/test-*.sh "$SCRIPT_DIR/run-tests.sh" 2>/dev/null \
  | grep -v "test-0000314-req-003" || true)"
assert_equals "" "$HITS" "req-003 AC-2: no test moves, renames, or deletes the live step log folder"

PLANT='mv "$REPO_ROOT/plan/.initiative-logs" /tmp/x'
PLANT_HIT="$(printf '%s\n' "$PLANT" | grep -E "$PATTERN" || true)"
assert_contains ".initiative-logs" "$PLANT_HIT" "req-003 AC-2: the pattern matches a planted move of the live folder"

print_summary
