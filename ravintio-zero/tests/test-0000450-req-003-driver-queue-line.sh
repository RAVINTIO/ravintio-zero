#!/usr/bin/env bash
# Tests for feature 0000450, REQ-003: when the merge queue fails for a step, the concurrent driver
# prints the queue stopped line at once and appends it to the step log. The stop at exit repeats it.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="${DRIVER:-$SCRIPT_DIR/../scripts/initiative-run.mjs}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

LINE="I-D Advance: Blocked: queue stopped on step 1. merge-queue: CI failed on PR #101"

echo ""
echo "=== REQ-003 AC-1: the reason prints at the failure ==="
R="$(make_repo line 2 '1||' '2||')"
STUB_MODE_2=afterdone:1 QUEUE_FAIL_STEP=1 run_sched "$R"
assert_equals "1" "$CODE" "REQ-003 AC-1: driver exits 1"
assert_contains "$LINE" "$OUT" "REQ-003 AC-1: stdout holds the queue stopped line with the reason"
FIRST="$(grep -n -F -- "$LINE" <<< "$OUT" | head -1 | cut -d: -f1)"
STOPPING="$(grep -n -F -- "I-C Run: Stopping:" <<< "$OUT" | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$FIRST" ] && [ -n "$STOPPING" ] && [ "$FIRST" -lt "$STOPPING" ] && echo yes || echo no)" "REQ-003 AC-1: the line comes before the Stopping line"
assert_equals "2" "$(grep -c -F -- "$LINE" <<< "$OUT")" "REQ-003 AC-1: the line prints at the failure and again at exit"
assert_contains "$LINE" "$(tail -3 "$(dirname "$R")/out.txt")" "REQ-003: the stop at exit still repeats the line"

echo ""
echo "=== REQ-003 AC-2: the step log holds the line ==="
LOG="$R/plan/.initiative-logs/step-1.log"
assert_equals "$LINE" "$(tail -1 "$LOG")" "REQ-003 AC-2: step-1.log ends with the same line"
assert_equals "1" "$(grep -c -F -- "$LINE" "$LOG")" "REQ-003 AC-2: the log holds the line once"

print_summary
