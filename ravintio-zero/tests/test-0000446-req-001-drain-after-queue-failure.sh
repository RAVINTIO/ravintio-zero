#!/usr/bin/env bash
# Tests for feature 0000446, REQ-001: after a queue failure the driver keeps queueing the other
# ready PRs, one attempt per step, and still exits 1 with the first stop line.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

echo ""
echo "=== REQ-001 AC-1 and AC-2: step 2 merges after the queue fails on step 1 ==="
R="$(make_repo drain 2 '1||' '2||')"
STUB_MODE_2=afterdone:1 QUEUE_FAIL_STEP=1 run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "1" "$CODE" "REQ-001 AC-2: driver exits 1"
assert_equals "1 101,2 102," "$(tr '\n' ',' < "$S/queue.log")" "REQ-001 AC-1: the queue runs for step 1, then step 2"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-1: step 2 reads merged on the initiative branch"
assert_equals "pending" "$(origin_status "$R" 1)" "REQ-001 AC-2: step 1 stays pending"
assert_contains "I-D Advance: Blocked: queue stopped on step 1. merge-queue: CI failed on PR #101" "$OUT" "REQ-001 AC-2: the Blocked line names step 1"
assert_contains "I-D Advance: Complete: step 2 merged" "$OUT" "REQ-001 AC-1: prints the step 2 merge"
assert_contains "I-C Run: Step 1: stopped" "$OUT" "REQ-001 AC-2: the report shows step 1 stopped"
assert_contains "I-C Run: Step 2: merged" "$OUT" "REQ-001 AC-2: the report shows step 2 merged"
assert_contains "Log: plan/.initiative-logs/step-1.log" "$(tail -1 "$(dirname "$R")/out.txt")" "REQ-001 AC-2: the stop line names the first failure log"
assert_equals "101" "$(cat "$R/plan/.initiative-control/step-1/ready" 2>/dev/null)" "REQ-001: the failed step keeps its ready file"

echo ""
echo "=== REQ-001 AC-3: every ready PR fails, each gets one attempt ==="
R="$(make_repo allfail 2 '1||' '2||')"
STUB_MODE_2=afterdone:1 QUEUE_FAIL_STEP=1,2 run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "1" "$CODE" "REQ-001 AC-3: driver exits 1"
assert_equals "1 101,2 102," "$(tr '\n' ',' < "$S/queue.log")" "REQ-001 AC-3: one queue run for each step"
assert_contains "queue stopped on step 2" "$OUT" "REQ-001 AC-3: the Blocked line names step 2"

echo ""
echo "=== REQ-001: a dependent step still does not start after a failure ==="
R="$(make_repo dep 2 '1||' '2||1')"
QUEUE_FAIL_STEP=1 run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "no" "$([ -e "$S/step-2.env" ] && echo yes || echo no)" "REQ-001: step 2 never starts"
assert_contains "I-C Run: Step 2: pending" "$OUT" "REQ-001: step 2 reads pending"

print_summary
