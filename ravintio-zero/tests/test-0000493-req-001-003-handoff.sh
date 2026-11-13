#!/usr/bin/env bash
# Tests for feature 0000493-driver-starts-after-restart, REQ-001 to REQ-003: after a Restart-only merge
# the concurrent driver hands new starts to a successor driver, which adopts the running steps.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh). The old driver and its successor share one output file.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"; [ -n "${SLEEPER:-}" ] && kill "$SLEEPER" 2>/dev/null' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { [ -e "$1" ] && echo yes || echo no; }
count_lines() { grep -c "^$2\$" "$1" 2>/dev/null || true; }

# wait_gone <path>: waits up to 40 s for the path to vanish. The successor removes the lock last.
wait_gone() {
  local i
  for i in $(seq 400); do [ -e "$1" ] || return 0; sleep 0.1; done
  return 1
}

# finish <root>: waits for the successor to release the lock, then reloads OUT.
finish() {
  wait_gone "$1/plan/.initiative-runner.lock"
  OUT="$(cat "$(dirname "$1")/out.txt")"
}

echo ""
echo "=== REQ-001 AC-1, REQ-002 AC-1, AC-2: a Restart-only merge hands over ==="
R="$(make_repo handoff 2 '1||' '2||' '3||1')"
S="$(dirname "$R")/stub"
QUEUE_RESTART_STEP=1 STUB_MODE_2=pair:3 run_sched "$R"
OLD_CODE="$CODE"
finish "$R"
assert_equals "0" "$OLD_CODE" "REQ-001 AC-1: the old driver exits 0"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs. A new driver took over new starts." "$OUT" "REQ-001 AC-1: prints the handoff line"
assert_not_contains "Start a new driver so" "$OUT" "REQ-001 AC-1: no stop line"
assert_equals "yes" "$(yes_no "$S/2.overlap")" "REQ-001 AC-1: step 3 started while step 2 still ran"
assert_equals "1" "$(count_lines "$S/claude.log" 2)" "REQ-002 AC-1: step 2 had one session"
assert_equals "1" "$(count_lines "$S/claude.log" 3)" "REQ-001 AC-1: step 3 had one session"
for n in 1 2 3; do
  assert_equals "1" "$(awk -v n="$n" '$1 == n' "$S/queue.log" | wc -l | tr -d ' ')" "REQ-002 AC-2: step $n went through the queue once"
  assert_equals "merged" "$(origin_status "$R" "$n")" "REQ-002 AC-2: step $n merged on origin"
done
assert_contains "I-E Delivery: Pending: all 3 steps merged" "$OUT" "REQ-001 AC-1: the successor reaches delivery"
assert_equals "no" "$(yes_no "$R/plan/.initiative-runner.lock")" "REQ-001 AC-1: lock released at the end"

echo ""
echo "=== REQ-001 AC-3: a root that cannot fast-forward keeps the stop ==="
R="$(make_repo noff 2 '1||' '2||1')"
S="$(dirname "$R")/stub"
mkdir -p "$R/ravintio-zero/scripts"
printf '// local\n' > "$R/ravintio-zero/scripts/initiative-run.mjs"
QUEUE_RESTART_STEP=1 run_sched "$R"
assert_equals "75" "$CODE" "REQ-001 AC-3: driver exits 75"
assert_contains "I-D Advance: Restart: step 1 changed ravintio-zero/scripts/initiative-run.mjs. Start a new driver so the next step runs the new code." "$OUT" "REQ-001 AC-3: prints the existing stop"
assert_not_contains "took over new starts" "$OUT" "REQ-001 AC-3: no handoff line"
assert_equals "no" "$(yes_no "$S/step-2.env")" "REQ-001 AC-3: step 2 never starts"

echo ""
echo "=== REQ-001 AC-2: a Setup hit keeps the stop ==="
R="$(make_repo setup 2 '1||' '2||1')"
S="$(dirname "$R")/stub"
QUEUE_SETUP_STEP=1 run_sched "$R"
assert_equals "1" "$CODE" "REQ-001 AC-2: driver exits 1"
assert_contains "I-D Advance: Setup: step 1 changed ravintio-zero/skills/s.md." "$OUT" "REQ-001 AC-2: prints the Setup stop"
assert_not_contains "took over new starts" "$OUT" "REQ-001 AC-2: no handoff line"
assert_equals "no" "$(yes_no "$S/step-2.env")" "REQ-001 AC-2: step 2 never starts"
R="$(make_repo both 2 '1||' '2||1')"
QUEUE_RESTART_STEP=1 QUEUE_SETUP_STEP=1 run_sched "$R"
assert_equals "75" "$CODE" "REQ-001 AC-2 (both): driver exits 75"
assert_contains "I-D Advance: Restart: Setup: step 1 changed" "$OUT" "REQ-001 AC-2 (both): prints the combined stop"
assert_not_contains "took over new starts" "$OUT" "REQ-001 AC-2 (both): no handoff line"

echo ""
echo "=== REQ-003 AC-1, AC-2: a block after the handoff stops new starts ==="
R="$(make_repo late 2 '1||' '2||' '3||1' '4||1')"
S="$(dirname "$R")/stub"
QUEUE_RESTART_STEP=1 STUB_MODE_2=blocklate:3 STUB_MODE_3=waitstop run_sched "$R"
OLD_CODE="$CODE"
finish "$R"
assert_equals "1" "$OLD_CODE" "REQ-003 AC-1: the old driver exits 1"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-control/step-2/stopped")" "REQ-003 AC-1: the old driver wrote the stopped file"
assert_contains "I-C Run: Blocked: step 2 stopped. Blocked: step 2 cannot go on" "$(cat "$R/plan/.initiative-control/step-2/stopped")" "REQ-003 AC-1: the file holds the stop line"
assert_equals "no" "$(yes_no "$S/step-4.env")" "REQ-003 AC-2: step 4 never starts"
assert_equals "1" "$(count_lines "$S/claude.log" 3)" "REQ-003 AC-2: step 3 started once"
assert_equals "no" "$(yes_no "$R/plan/.initiative-runner.lock")" "REQ-003 AC-2: lock released"
assert_contains "I-C Run: Step 4: pending" "$OUT" "REQ-003 AC-2: the successor reports step 4 pending"

echo ""
echo "=== REQ-002 AC-3: a dead supervisor restarts the session ==="
R="$(make_repo dead 1 '1||')"
S="$(dirname "$R")/stub"
sleep 0 & DEAD=$!
wait "$DEAD" 2>/dev/null
mkdir -p "$R/plan/.initiative-control/step-1"
printf '%s\n' "$DEAD" > "$R/plan/.initiative-control/step-1/running"
base="$(dirname "$R")"
(cd "$R" && PATH="$WORK/bin:$PATH" STUB_DIR="$S" STUB_ROOT="$R" DRIVER_OUT="$base/out.txt" MERGE_QUEUE_BIN="$WORK/bin/queue.mjs" \
  exec node "$DRIVER" --root "$R" --handoff "$DEAD" > "$base/out.txt" 2> "$base/err.txt") &
CHILD=$!
printf '%s\n' "$CHILD" > "$R/plan/.initiative-runner.lock"
wait "$CHILD"
CODE=$?
OUT="$(cat "$base/out.txt")"
assert_equals "0" "$CODE" "REQ-002 AC-3: the successor exits 0"
assert_equals "1" "$(count_lines "$S/claude.log" 1)" "REQ-002 AC-3: step 1 got one new session"
assert_equals "merged" "$(origin_status "$R" 1)" "REQ-002 AC-3: step 1 merged"

echo ""
echo "=== REQ-003 AC-2: the successor stops on a stopped file and cuts it to 500 characters ==="
R="$(make_repo cut 2 '1||' '2||1')"
S="$(dirname "$R")/stub"
base="$(dirname "$R")"
sleep 60 & SLEEPER=$!
mkdir -p "$R/plan/.initiative-control/step-1"
printf '%s\n' "$SLEEPER" > "$R/plan/.initiative-control/step-1/running"
LONG="$(printf 'x%.0s' $(seq 2000))"
printf 'I-C Run: Blocked: step 1 stopped. %s\n' "$LONG" > "$R/plan/.initiative-control/step-1/stopped"
(cd "$R" && PATH="$WORK/bin:$PATH" STUB_DIR="$S" STUB_ROOT="$R" DRIVER_OUT="$base/out.txt" MERGE_QUEUE_BIN="$WORK/bin/queue.mjs" \
  exec node "$DRIVER" --root "$R" --handoff "$SLEEPER" > "$base/out.txt" 2> "$base/err.txt") &
CHILD=$!
printf '%s\n' "$CHILD" > "$R/plan/.initiative-runner.lock"
wait "$CHILD"
CODE=$?
kill "$SLEEPER" 2>/dev/null
SLEEPER=""
OUT="$(cat "$base/out.txt")"
assert_equals "1" "$CODE" "REQ-003 AC-2 (cut): the successor exits 1"
assert_contains "I-C Run: Stopping:" "$OUT" "REQ-003 AC-2 (cut): prints Stopping"
assert_contains "I-C Run: Blocked: step 1 stopped." "$OUT" "REQ-003 AC-2 (cut): prints the stop line"
LONGEST="$(awk '{ if (length($0) > m) m = length($0) } END { print m }' "$base/out.txt")"
assert_equals "yes" "$([ "$LONGEST" -lt 700 ] && echo yes || echo no)" "REQ-003 AC-2 (cut): no output line passes 700 characters ($LONGEST)"
assert_equals "no" "$(yes_no "$S/step-2.env")" "REQ-003 AC-2 (cut): step 2 never starts"

echo ""
echo "=== REQ-003 AC-3: a stale stopped file never stops a fresh driver ==="
R="$(make_repo stale 1 '1||')"
mkdir -p "$R/plan/.initiative-control/step-1"
printf 'I-C Run: Blocked: step 1 stopped. old\n' > "$R/plan/.initiative-control/step-1/stopped"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-003 AC-3: the driver exits 0"
assert_equals "merged" "$(origin_status "$R" 1)" "REQ-003 AC-3: step 1 merged"

print_summary
