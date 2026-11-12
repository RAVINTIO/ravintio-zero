#!/usr/bin/env bash
# Tests for feature 0000501-remove-merged-worktrees, REQ-001 to REQ-004: at start the driver removes
# the safe worktree of each merged step, keeps and reports every other worktree, and the docs say so.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh). Step 1 is already merged in the chart. Step 2 runs as normal.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
STANDARDS="$SCRIPT_DIR/../standards/roadmap-standards.md"
ADR="$SCRIPT_DIR/../../../docs/adr/0326-driver-sweeps-merged-worktrees.md"
WORK="$(mktemp -d)"
LIVE_PID=""
trap '[ -n "$LIVE_PID" ] && kill "$LIVE_PID" 2>/dev/null; rm -rf "$WORK"' EXIT
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { [ -e "$1" ] && echo yes || echo no; }

# Builds a repo whose chart marks step 1 merged, then adds the step 1 worktree on feat/0000051-s1.
# $2 is "push" to publish the branch on origin, and anything else leaves it local.
merged_repo() {
  local name="$1" push="$2" r
  r="$(make_repo "$name" 1 '1||' '2||1')"
  sed -i.bak '/^| 1 |/ s/| pending |/| merged |/' "$r/plan/current-initiative/initiative.md"
  rm -f "$r/plan/current-initiative/initiative.md.bak"
  git -C "$r" commit -q -am "step 1 merged"
  git -C "$r" push -q origin "$BRANCH_NAME"
  git -C "$r" worktree add -q --no-track -b feat/0000051-s1 "$r/plan/.initiative-worktrees/step-1" HEAD
  [ "$push" = push ] && git -C "$r" push -q origin feat/0000051-s1
  printf '%s' "$r"
}

echo ""
echo "=== REQ-001 AC-1, AC-3: a clean merged worktree goes, a missing one prints nothing ==="
R="$(merged_repo clean push)"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-001 AC-1: driver exits 0"
assert_equals "no" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-001 AC-1: the step 1 worktree is gone"
assert_not_contains "Kept:" "$OUT" "REQ-001 AC-1: no Kept line"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-1: step 2 merged"
R="$(make_repo none 1 '1||' '2||1')"
sed -i.bak '/^| 1 |/ s/| pending |/| merged |/' "$R/plan/current-initiative/initiative.md"
rm -f "$R/plan/current-initiative/initiative.md.bak"
git -C "$R" commit -q -am "step 1 merged"
git -C "$R" push -q origin "$BRANCH_NAME"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-001 AC-3: driver exits 0 with no worktree"
assert_not_contains "Kept:" "$OUT" "REQ-001 AC-3: no Kept line"

echo ""
echo "=== REQ-001 AC-2: the worktree of an unmerged step stays ==="
R="$(merged_repo unmerged push)"
STUB_MODE_2=block run_sched "$R"
assert_equals "1" "$CODE" "REQ-001 AC-2: driver exits 1 on the block"
assert_equals "no" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-001 AC-2: the merged worktree is gone"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-2")" "REQ-001 AC-2: the step 2 worktree remains"
assert_not_contains "Kept: step 2" "$OUT" "REQ-001 AC-2: step 2 is not swept"

echo ""
echo "=== REQ-002 AC-1, AC-3: an uncommitted file keeps the worktree and the run goes on ==="
R="$(merged_repo dirty push)"
printf 'notes\n' > "$R/plan/.initiative-worktrees/step-1/notes.txt"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-002 AC-3: driver exits 0"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1/notes.txt")" "REQ-002 AC-1: the file remains"
assert_contains "I-C Run: Kept: step 1 worktree holds uncommitted files: notes.txt" "$OUT" "REQ-002 AC-1: names the file"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-002 AC-3: step 2 merged"

echo ""
echo "=== REQ-002 AC-2: a git failure keeps the worktree ==="
R="$(merged_repo broken push)"
printf 'gitdir: /nonexistent/worktree\n' > "$R/plan/.initiative-worktrees/step-1/.git"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-002 AC-2: driver exits 0"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-002 AC-2: the worktree remains"
assert_contains "Kept: step 1 worktree could not be inspected" "$OUT" "REQ-002 AC-2: says git failed"

echo ""
echo "=== REQ-003 AC-1: an unpushed commit keeps the worktree ==="
R="$(merged_repo unpushed push)"
git -C "$R/plan/.initiative-worktrees/step-1" commit -q --allow-empty -m "local only"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-003 AC-1: driver exits 0"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-003 AC-1: the worktree remains"
assert_contains "Kept: step 1 worktree head is not on origin/feat/0000051-s1" "$OUT" "REQ-003 AC-1: names the branch"

echo ""
echo "=== REQ-003 AC-2: a branch gone from origin does not keep a clean worktree ==="
R="$(merged_repo gone nopush)"
run_sched "$R"
assert_equals "0" "$CODE" "REQ-003 AC-2: driver exits 0"
assert_equals "no" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-003 AC-2: the worktree is gone"
assert_not_contains "Kept:" "$OUT" "REQ-003 AC-2: no Kept line"

echo ""
echo "=== REQ-003 AC-3: a live session keeps the worktree ==="
R="$(merged_repo live push)"
sleep 60 &
LIVE_PID=$!
mkdir -p "$R/plan/.initiative-control/step-1"
printf '%s\n' "$LIVE_PID" > "$R/plan/.initiative-control/step-1/running"
run_sched "$R"
kill "$LIVE_PID" 2>/dev/null
LIVE_PID=""
assert_equals "0" "$CODE" "REQ-003 AC-3: driver exits 0"
assert_equals "yes" "$(yes_no "$R/plan/.initiative-worktrees/step-1")" "REQ-003 AC-3: the worktree remains"
assert_contains "Kept: step 1 a session still runs" "$OUT" "REQ-003 AC-3: says a session runs"

echo ""
echo "=== REQ-004 AC-1, AC-2: the driver header, the standards, and the ADR state the sweep ==="
assert_contains "merged step" "$(sed -n 1,170p "$DRIVER")" "REQ-004 AC-1: the driver header states the sweep"
assert_contains "I-C Run: Kept:" "$(sed -n 1,170p "$DRIVER")" "REQ-004 AC-1: the driver header names the Kept line"
assert_contains "sweep" "$(cat "$STANDARDS")" "REQ-004 AC-2: roadmap-standards.md states the sweep"
assert_contains "I-C Run: Kept:" "$(cat "$STANDARDS")" "REQ-004 AC-2: roadmap-standards.md names the Kept line"
assert_contains "I-C Run: Kept:" "$(cat "$ADR")" "REQ-004: the ADR names the Kept line"

print_summary
