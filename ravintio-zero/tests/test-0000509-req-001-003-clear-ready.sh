#!/usr/bin/env bash
# Tests for feature 0000509-clear-merged-ready-files, REQ-001 to REQ-003: at start the driver removes
# the ready file of each merged step, keeps and reports a file it cannot clear, and the docs say so.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh). Step 1 is already merged in the chart. Step 2 runs as normal.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
ADR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)/docs/adr/0340-driver-clears-merged-ready-files.md"
WORK="$(mktemp -d)"
LIVE_PID=""
trap '[ -n "$LIVE_PID" ] && kill "$LIVE_PID" 2>/dev/null; rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { [ -e "$1" ] && echo yes || echo no; }

# Builds a repo whose chart marks step 1 merged. $2 is "ready" to leave a ready file in the control
# folder of step 1, and anything else leaves the folder out.
merged_repo() {
  local name="$1" ready="$2" r
  r="$(make_repo "$name" 1 '1||' '2||1')"
  sed -i.bak '/^| 1 |/ s/| pending |/| merged |/' "$r/plan/current-initiative/initiative.md"
  rm -f "$r/plan/current-initiative/initiative.md.bak"
  git -C "$r" commit -q -am "step 1 merged"
  git -C "$r" push -q origin "$BRANCH_NAME"
  if [ "$ready" = ready ]; then
    mkdir -p "$r/plan/.initiative-control/step-1"
    printf '41\n' > "$r/plan/.initiative-control/step-1/ready"
  fi
  printf '%s' "$r"
}

echo ""
echo "=== REQ-001 AC-1: the ready file of a merged step goes ==="
R="$(merged_repo clean ready)"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-001 AC-1: driver exits 0"
assert_equals "no" "$(yes_no "$R/plan/.initiative-control/step-1/ready")" "REQ-001 AC-1: the ready file is gone"
assert_contains "I-C Run: Cleared: step 1 ready file of a merged step" "$OUT" "REQ-001 AC-1: prints the Cleared line"
assert_not_contains "Kept:" "$OUT" "REQ-001 AC-1: no Kept line"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-1: step 2 merged"

echo ""
echo "=== REQ-001 AC-2: the ready file of an unmerged step stays ==="
R="$(merged_repo unmerged ready)"
mkdir -p "$R/plan/.initiative-control/step-2"
printf '42\n' > "$R/plan/.initiative-control/step-2/ready"
run_sched "$R"
assert_not_contains "Cleared: step 2" "$OUT" "REQ-001 AC-2: step 2 is not cleared"
assert_equals "no" "$(yes_no "$R/plan/.initiative-control/step-1/ready")" "REQ-001 AC-2: step 1 is cleared"

echo ""
echo "=== REQ-001 AC-3: no ready file, no output ==="
R="$(merged_repo none none)"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-001 AC-3: driver exits 0"
assert_not_contains "Cleared:" "$OUT" "REQ-001 AC-3: no Cleared line"
assert_not_contains "Kept: step 1" "$OUT" "REQ-001 AC-3: no Kept line"

echo ""
echo "=== REQ-001: other control files stay ==="
R="$(merged_repo others ready)"
printf 'stop\n' > "$R/plan/.initiative-control/step-1/stopped"
run_sched "$R"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-control/step-1/stopped")" "REQ-001: the stopped file remains"

echo ""
echo "=== REQ-002 AC-1: a live session keeps the ready file ==="
R="$(merged_repo live ready)"
sleep 60 &
LIVE_PID=$!
printf '%s\n' "$LIVE_PID" > "$R/plan/.initiative-control/step-1/running"
run_sched "$R"
kill "$LIVE_PID" 2>/dev/null
LIVE_PID=""
assert_equals "0" "$CODE" "REQ-002 AC-1: driver exits 0"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-control/step-1/ready")" "REQ-002 AC-1: the ready file remains"
assert_contains "I-C Run: Kept: step 1 a session still runs" "$OUT" "REQ-002 AC-1: says a session runs"

echo ""
echo "=== REQ-002 AC-2: a symlinked control path keeps the file and the run goes on ==="
R="$(merged_repo link none)"
mkdir -p "$WORK/outside"
printf '43\n' > "$WORK/outside/ready"
mkdir -p "$R/plan/.initiative-control"
ln -s "$WORK/outside" "$R/plan/.initiative-control/step-1"
run_sched "$R"
assert_equals "yes" "$(yes_no "$WORK/outside/ready")" "REQ-002 AC-2: the file behind the link remains"
assert_contains "I-C Run: Kept: step 1" "$OUT" "REQ-002 AC-2: prints a Kept line"

echo ""
echo "=== REQ-002 AC-3: a dead pid does not keep the ready file ==="
R="$(merged_repo dead ready)"
sleep 0 &
DEAD_PID=$!
wait "$DEAD_PID" 2>/dev/null
printf '%s\n' "$DEAD_PID" > "$R/plan/.initiative-control/step-1/running"
run_sched "$R"
assert_equals "no" "$(yes_no "$R/plan/.initiative-control/step-1/ready")" "REQ-002 AC-3: the ready file is gone"
assert_contains "Cleared: step 1" "$OUT" "REQ-002 AC-3: prints the Cleared line"

echo ""
echo "=== REQ-003 AC-1, AC-2: the driver header, the standards, and the ADR state the clearing ==="
assert_contains "I-C Run: Cleared:" "$(sed -n 1,175p "$DRIVER")" "REQ-003 AC-1: the driver header names the Cleared line"
assert_contains "ready file of each merged step" "$(sed -n 1,175p "$DRIVER")" "REQ-003 AC-1: the driver header states the clearing"
assert_contains "I-C Run: Cleared:" "$(cat "$STANDARDS")" "REQ-003 AC-2: roadmap-standards.md names the Cleared line"
assert_contains "file of each merged step" "$(cat "$STANDARDS")" "REQ-003 AC-2: roadmap-standards.md states the clearing"
assert_contains "I-C Run: Cleared:" "$(cat "$ADR")" "REQ-003: the ADR names the Cleared line"

print_summary
