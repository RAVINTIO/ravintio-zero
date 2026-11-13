#!/usr/bin/env bash
# Tests for feature 0000379, REQ-004 AC-1 and AC-3: the concurrent driver hands each ready step to
# the merge queue, one PR at a time in ready order, and stops on a queue failure.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { [ -e "$1" ] && echo yes || echo no; }

echo ""
echo "=== REQ-004 AC-1: two steps merge through the queue in ready order ==="
R="$(make_repo order 2 '1||' '2||')"
STUB_MODE_1=afterdone:2 run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "0" "$CODE" "REQ-004 AC-1: driver exits 0"
assert_equals "2 102,1 101," "$(tr '\n' ',' < "$S/queue.log")" "REQ-004 AC-1: one queue run per PR, in ready order"
assert_equals "2 gone,1 gone," "$(tr '\n' ',' < "$S/queue-wt.log")" "REQ-004 AC-1: the step worktree is gone before its queue run"
assert_equals "merged" "$(origin_status "$R" 1)" "REQ-004 AC-1: step 1 reads merged"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-004 AC-1: step 2 reads merged"
assert_contains "I-D Advance: Complete: step 2 merged" "$OUT" "REQ-004 AC-1: prints the step 2 merge"
assert_contains "I-D Advance: Complete: step 1 merged" "$OUT" "REQ-004 AC-1: prints the step 1 merge"
assert_contains "merged PR #102" "$(cat "$R/plan/.initiative-logs/step-2.log")" "REQ-004 AC-1: the queue output goes to the step log"
assert_equals "yes" "$(git -C "$R/plan/.initiative-worktrees/queue" rev-parse --is-inside-work-tree 2>/dev/null | sed 's/true/yes/')" "REQ-004 AC-1: the queue worktree exists"

echo ""
echo "=== REQ-004 AC-3: a queue failure stops the driver ==="
R="$(make_repo fail 2 '1||' '2||1')"
QUEUE_FAIL_STEP=1 run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "1" "$CODE" "REQ-004 AC-3: driver exits 1"
assert_contains "I-D Advance: Blocked: queue stopped on step 1. merge-queue: CI failed on PR #101" "$OUT" "REQ-004 AC-3: the Blocked line names the step and the queue error"
assert_equals "no" "$(yes_no "$S/step-2.env")" "REQ-004 AC-3: no new step starts"
assert_contains "I-C Run: Step 1: ready" "$OUT" "REQ-004 AC-3: report names step 1 ready"
assert_contains "I-C Run: Step 2: pending" "$OUT" "REQ-004 AC-3: report names step 2 pending"
assert_contains "Log: plan/.initiative-logs/step-1.log" "$(tail -1 "$(dirname "$R")/out.txt")" "REQ-004 AC-3: the stop line names the log"

echo ""
echo "=== REQ-004: a restarted driver queues a ready step without a new session ==="
R="$(make_repo resume 1 '1||')"
mkdir -p "$R/plan/.initiative-control/step-1"
printf '101\n' > "$R/plan/.initiative-control/step-1/ready"
run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "0" "$CODE" "REQ-004 (restart): driver exits 0"
assert_equals "no" "$(yes_no "$S/claude.log")" "REQ-004 (restart): no claude session ran"
assert_equals "1 101," "$(tr '\n' ',' < "$S/queue.log")" "REQ-004 (restart): the queue ran for the ready PR"

echo ""
echo "=== REQ-004: an invalid ready file stops the driver ==="
R="$(make_repo badready 1 '1||')"
mkdir -p "$R/plan/.initiative-control/step-1"
printf '1; rm -rf /\n' > "$R/plan/.initiative-control/step-1/ready"
RAVINTIO_GH_BIN=false run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "1" "$CODE" "REQ-004 (bad ready): driver exits 1"
assert_contains "I-C Run: Blocked: step 1 wrote an invalid ready file" "$OUT" "REQ-004 (bad ready): names the invalid file"
assert_equals "no" "$(yes_no "$S/queue.log")" "REQ-004 (bad ready): the queue never ran"

print_summary
