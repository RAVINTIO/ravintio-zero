#!/usr/bin/env bash
# Tests for feature 0000555-initiative-pause-reaches-every-step, req-002: the driver reads the pause
# request, starts no step, stops each session at a phase end, writes the records, and resumes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
PAUSE="$SCRIPT_DIR/../scripts/initiative-pause.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

wait_for() {
  local i
  for i in $(seq 150); do [ -e "$1" ] && return 0; sleep 0.1; done
  return 1
}

echo ""
echo "=== req-002 AC-1: a pause request stops new starts ==="
R="$(make_repo nostart 2 '1||' '2||')"
node "$PAUSE" request --root "$R" >/dev/null 2>&1
run_sched "$R"
S="$(dirname "$R")/stub"
assert_equals "0" "$CODE" "AC-1: the driver exits 0"
assert_equals "no" "$([ -e "$S/claude.log" ] && echo yes || echo no)" "AC-1: no session starts"
assert_contains "I-C Run: Paused: 0 steps merged, 0 steps hold a pause record" "$OUT" "AC-1: prints the Paused line"
assert_equals "yes" "$([ -f "$R/plan/current-initiative/pause.md" ] && echo yes || echo no)" "AC-1: the initiative record exists"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-1: the lock is released"
assert_contains "action for the human: read plan/current-initiative/pause.md" "$OUT" "AC-1: the summary names the action"

echo ""
echo "=== req-002 AC-2: running sessions stop at a phase end ==="
R="$(make_repo twostep 2 '1||' '2||' '3||')"
base="$(dirname "$R")"
S="$base/stub"
: > "$base/out.txt"
(cd "$R" && PATH="$WORK/bin:$PATH" STUB_DIR="$S" STUB_ROOT="$R" DRIVER_OUT="$base/out.txt" STUB_MODE_1=longrun STUB_MODE_2=longrun \
  MERGE_QUEUE_BIN="$WORK/bin/queue.mjs" node "$DRIVER" --root "$R" > "$base/out.txt" 2>"$base/err.txt"; echo $? > "$base/code.txt") &
DRIVER_PID=$!
wait_for "$S/1.started"; wait_for "$S/2.started"
sleep 1
node "$PAUSE" request --root "$R" >/dev/null 2>&1
wait_for_line() {
  local i
  for i in $(seq 100); do grep -q "$1" "$base/out.txt" && return 0; sleep 0.1; done
  return 1
}
wait_for_line "I-C Run: Pausing:"
WT1="$R/plan/.initiative-worktrees/step-1/plan/current/build-log.md"
WT2="$R/plan/.initiative-worktrees/step-2/plan/current/build-log.md"
printf -- '- Complete: P2 (2026-11-15T10:00:00Z)\n' >> "$WT1"
printf -- '- Complete: P2 (2026-11-15T10:00:00Z)\n' >> "$WT2"
wait "$DRIVER_PID"
OUT="$(cat "$base/out.txt")"
assert_equals "0" "$(cat "$base/code.txt")" "AC-2: the driver exits 0"
assert_contains "I-C Run: Paused: 0 steps merged, 2 steps hold a pause record" "$OUT" "AC-2: prints the Paused line"
assert_equals "no" "$([ -e "$S/3.started" ] && echo yes || echo no)" "AC-2: step 3 never starts"
assert_equals "yes" "$([ -f "$R/plan/.initiative-worktrees/step-1/plan/current/pause.md" ] && echo yes || echo no)" "AC-2: step 1 holds a pause record"
assert_equals "yes" "$([ -f "$R/plan/.initiative-worktrees/step-2/plan/current/pause.md" ] && echo yes || echo no)" "AC-2: step 2 holds a pause record"
assert_equals "yes" "$([ -f "$R/plan/current-initiative/pause.md" ] && echo yes || echo no)" "AC-2: the initiative record exists"
assert_equals "no" "$([ -e "$R/plan/.initiative-runner.lock" ] && echo yes || echo no)" "AC-2: the lock is released"
assert_not_contains "Blocked:" "$OUT" "AC-2: no stop line"

echo ""
echo "=== req-002 AC-3: a new driver resumes ==="
run_sched "$R"
assert_equals "0" "$CODE" "AC-3: the driver exits 0"
assert_contains "I-C Run: Resuming: initiative pause record read" "$OUT" "AC-3: prints the resume line"
assert_equals "no" "$([ -e "$R/plan/current-initiative/pause.md" ] && echo yes || echo no)" "AC-3: the initiative record is removed"
assert_equals "no" "$([ -e "$R/plan/.initiative-control/pause" ] && echo yes || echo no)" "AC-3: the request is removed"
assert_contains "I-D Advance: Complete: step 1 merged" "$OUT" "AC-3: step 1 merges"
assert_contains "I-D Advance: Complete: step 3 merged" "$OUT" "AC-3: step 3 merges"

print_summary
