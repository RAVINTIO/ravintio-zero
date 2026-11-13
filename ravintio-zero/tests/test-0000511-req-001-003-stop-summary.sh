#!/usr/bin/env bash
# Tests for feature 0000511-driver-stop-summary, REQ-001 to REQ-003: the driver ends every run with a
# summary block of the merged steps, its own fixes, and the one action left for the human.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
ADR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)/docs/adr/0341-driver-stop-summary.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

last_line() { printf '%s\n' "$1" | tail -n 1; }
# The summary block sits before the final line, so the action line is the one before it.
action_line() { printf '%s\n' "$1" | grep 'Summary: action for the human' | tail -n 1; }

echo ""
echo "=== REQ-001 AC-1, AC-3: a clean run lists the merged steps and no fixes ==="
R="$(make_repo clean 2 '1||' '2||1')"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-001 AC-1: driver exits 0"
assert_contains "I-C Run: Summary: merged this run: 1, 2" "$OUT" "REQ-001 AC-1: names both merged steps"
assert_contains "I-C Run: Summary: driver fixes: 0" "$OUT" "REQ-001 AC-3: counts no fixes"
assert_not_contains "Summary: fix:" "$OUT" "REQ-001 AC-3: prints no fix line"

echo ""
echo "=== REQ-002 AC-1: a clean end names its action and the final line stays last ==="
assert_contains "I-C Run: Summary: action for the human: " "$(action_line "$OUT")" "REQ-002 AC-1: prints the action line"
assert_contains "I-E Delivery: Pending:" "$(last_line "$OUT")" "REQ-002 AC-1: the final line stays the Pending line"
assert_contains "run initiative delivery from the initiative skill" "$(action_line "$OUT")" "REQ-002 AC-1: delivery is pending, so the action says so"

echo ""
echo "=== REQ-001 AC-3: a run that merges nothing says none ==="
R="$(make_repo nothing 2 '1||' '2||1')"
STUB_MODE_1=block run_sched "$R"
assert_contains "I-C Run: Summary: merged this run: none" "$OUT" "REQ-001 AC-3: lists none"

echo ""
echo "=== REQ-001 AC-2: a cleared ready file counts as a driver fix ==="
R="$(make_repo fix 2 '1||' '2||1')"
sed -i.bak '/^| 1 |/ s/| pending |/| merged |/' "$R/plan/current-initiative/initiative.md"
rm -f "$R/plan/current-initiative/initiative.md.bak"
git -C "$R" commit -q -am "step 1 merged"
git -C "$R" push -q origin "$BRANCH_NAME"
mkdir -p "$R/plan/.initiative-control/step-1"
printf '41\n' > "$R/plan/.initiative-control/step-1/ready"
run_sched "$R"
assert_contains "I-C Run: Summary: driver fixes: 1" "$OUT" "REQ-001 AC-2: counts one fix"
assert_contains "I-C Run: Summary: fix: I-C Run: Cleared: step 1 ready file of a merged step" "$OUT" "REQ-001 AC-2: names the fix"
assert_contains "I-C Run: Summary: merged this run: 2" "$OUT" "REQ-001 AC-2: lists only the step the run merged"

echo ""
echo "=== REQ-002 AC-2: a blocked step points at the stop line and the step log ==="
R="$(make_repo blocked 2 '1||' '2||1')"
STUB_MODE_1=block run_sched "$R"
assert_equals "1" "$CODE" "REQ-002 AC-2: driver still exits 1"
assert_equals "I-C Run: Summary: action for the human: read the stop line and the step log, then start a new driver" "$(action_line "$OUT" | sed -E 's/^[0-9]{2}:[0-9]{2} //')" "REQ-002 AC-2: names the action"
assert_contains "Blocked:" "$(last_line "$OUT")" "REQ-002 AC-2: the stop line stays last"

echo ""
echo "=== REQ-002 AC-3: a planned restart keeps exit 75 and names its action ==="
R="$(make_repo restart 2 '1||' '2||1')"
mkdir -p "$R/ravintio-zero/scripts"
printf '// local\n' > "$R/ravintio-zero/scripts/initiative-run.mjs"
QUEUE_RESTART_STEP=1 run_sched "$R"
assert_equals "75" "$CODE" "REQ-002 AC-3: driver exits 75"
assert_contains "I-C Run: Summary: merged this run: 1" "$OUT" "REQ-002 AC-3: lists the merged step"
assert_contains "action for the human: start a new driver" "$(action_line "$OUT")" "REQ-002 AC-3: names the action"
assert_contains "I-D Advance: Restart:" "$(last_line "$OUT")" "REQ-002 AC-3: the stop line stays last"

echo ""
echo "=== REQ-002: a setup stop keeps exit 1 and names its action ==="
R="$(make_repo setup 2 '1||' '2||1')"
QUEUE_SETUP_STEP=1 run_sched "$R"
assert_equals "1" "$CODE" "REQ-002: driver exits 1"
assert_contains "action for the human: run the setup command in the stop line, then start a new driver" "$(action_line "$OUT")" "REQ-002: names the action"

echo ""
echo "=== REQ-003: the driver header, the standards, and the ADR state the summary ==="
assert_contains "I-C Run: Summary:" "$(sed -n 1,200p "$DRIVER")" "REQ-003 AC-1: the driver header names the Summary lines"
assert_contains "I-C Run: Summary:" "$(cat "$STANDARDS")" "REQ-003 AC-2: roadmap-standards.md names the Summary lines"
assert_contains "I-C Run: Summary:" "$(cat "$ADR")" "REQ-003 AC-3: the ADR names the Summary lines"

print_summary
