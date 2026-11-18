#!/usr/bin/env bash
# Tests for feature 0000583-step-temp-cleanup-after-merge, REQ-001: after the queue merges a step,
# and at start for each merged step, the driver removes the step's temp paths and extra worktrees.
#
# Each case builds a real git repo with a bare origin, a stub claude, and a stub merge queue (see
# helpers/scheduler-fixture.sh). RAVINTIO_STEP_TEMP_DIRS points the driver at a scratch folder, so
# the test never touches the real temp folder.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d -t ravintio_0000583_req001_XXXXXX)"
trap 'chmod -R u+w "$WORK" 2>/dev/null; rm -rf "$WORK"' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT HUP
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { if [ -e "$1" ] || [ -L "$1" ]; then echo yes; else echo no; fi; }

# Builds a repo whose chart marks step 1 merged, and a scratch temp folder for the driver.
temp_repo() {
  local name="$1" r
  r="$(make_repo "$name" 1 '1||' '2||1')"
  sed -i.bak '/^| 1 |/ s/| pending |/| merged |/' "$r/plan/current-initiative/initiative.md"
  rm -f "$r/plan/current-initiative/initiative.md.bak"
  git -C "$r" commit -q -am "step 1 merged"
  git -C "$r" push -q origin "$BRANCH_NAME"
  mkdir -p "$WORK/$name/tmp"
  printf '%s' "$r"
}

run_with_tmp() {
  local r="$1"
  export RAVINTIO_STEP_TEMP_DIRS="$(dirname "$r")/tmp"
  run_sched "$r"
  unset RAVINTIO_STEP_TEMP_DIRS
}

echo ""
echo "=== REQ-001 AC-1, AC-2: a merged step loses its temp paths and extra worktrees, other steps keep theirs ==="
R="$(temp_repo clean)"
T="$(dirname "$R")/tmp"
mkdir -p "$T/step1-out" "$T/step2-out" "$T/step10-out" "$T/step20-out" "$T/other"
: > "$T/step1.log"; : > "$T/step2.log"; : > "$T/step3.log"
git -C "$R" worktree add -q --detach "$T/step1-basewt" HEAD
git -C "$R" worktree add -q --detach "$T/step2-basewt" HEAD
git -C "$R" worktree add -q --detach "$T/step20-basewt" HEAD
mkdir -p "$WORK/outside"; : > "$WORK/outside/keep.txt"
ln -s "$WORK/outside" "$T/step2-link"
run_with_tmp "$R"
assert_equals "0" "$CODE" "REQ-001 AC-1: driver exits 0"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-1: step 2 merged"
for p in step1-out step1.log step1-basewt step2-out step2.log step2-basewt step2-link; do
  assert_equals "no" "$(yes_no "$T/$p")" "REQ-001 AC-1: $p is gone"
done
for p in step10-out step20-out step3.log other step20-basewt; do
  assert_equals "yes" "$(yes_no "$T/$p")" "REQ-001 AC-2: $p stays"
done
assert_equals "yes" "$(yes_no "$WORK/outside/keep.txt")" "REQ-001 AC-1: the removal never follows a symlink"
WT_LIST="$(git -C "$R" worktree list)"
assert_not_contains "step1-basewt" "$WT_LIST" "REQ-001 AC-1: git no longer lists step1-basewt"
assert_not_contains "step2-basewt" "$WT_LIST" "REQ-001 AC-1: git no longer lists step2-basewt"
assert_contains "step20-basewt" "$WT_LIST" "REQ-001 AC-2: git still lists step20-basewt"
assert_not_contains "Kept:" "$OUT" "REQ-001 AC-1: no Kept line"

echo ""
echo "=== REQ-001 AC-3: a failed removal prints a Kept line and never stops the run ==="
if [ "$(id -u)" = "0" ]; then
  echo "SKIP: root ignores a read-only folder"
else
  R="$(temp_repo locked)"
  T="$(dirname "$R")/tmp"
  mkdir -p "$T/step2-locked"
  : > "$T/step2-locked/file"
  chmod 555 "$T/step2-locked"
  run_with_tmp "$R"
  chmod 755 "$T/step2-locked"
  assert_equals "0" "$CODE" "REQ-001 AC-3: driver exits 0"
  assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001 AC-3: step 2 merged"
  assert_contains "I-C Run: Kept: step 2" "$OUT" "REQ-001 AC-3: prints the Kept line for step 2"
fi

echo ""
echo "=== REQ-001: no temp path, no output ==="
R="$(temp_repo none)"
run_with_tmp "$R"
assert_not_contains "Kept:" "$OUT" "REQ-001: no Kept line"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-001: step 2 merged"

print_summary
