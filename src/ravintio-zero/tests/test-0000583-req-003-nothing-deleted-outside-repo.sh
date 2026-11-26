#!/usr/bin/env bash
# Tests for feature 0000583-step-temp-cleanup-after-merge, REQ-003: the driver deletes nothing outside
# the repo, and no pack script removes a path by name in a shared temp folder.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

DRIVER="$SCRIPT_DIR/../scripts/initiative-run.mjs"
WORK="$(mktemp -d -t ravintio_0000583_req003_XXXXXX)"
trap 'chmod -R u+w "$WORK" 2>/dev/null; rm -rf "$WORK"' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT HUP
source "$SCRIPT_DIR/helpers/scheduler-fixture.sh"

yes_no() { if [ -e "$1" ] || [ -L "$1" ]; then echo yes; else echo no; fi; }

echo ""
echo "=== REQ-003 AC-1: files in temp folders outside the repo survive a driver run ==="
R="$(make_repo planted 1 '1||' '2||1')"
OUTSIDE="$WORK/outside-tmp"
mkdir -p "$OUTSIDE/step1-out" "$OUTSIDE/step2-out"
: > "$OUTSIDE/step1.log"; : > "$OUTSIDE/step2.log"
export TMPDIR="$OUTSIDE" RAVINTIO_STEP_TEMP_DIRS="$OUTSIDE"
run_sched "$R"
unset RAVINTIO_STEP_TEMP_DIRS
assert_equals "0" "$CODE" "REQ-003 AC-1: driver exits 0"
assert_equals "merged" "$(origin_status "$R" 2)" "REQ-003 AC-1: step 2 merged"
for p in step1-out step2-out step1.log step2.log; do
  assert_equals "yes" "$(yes_no "$OUTSIDE/$p")" "REQ-003 AC-1: $p still exists"
done

echo ""
echo "=== REQ-003 AC-2: no pack script removes a path in a shared temp folder ==="
PACK="$SCRIPT_DIR/.."
BAD=""
for f in "$PACK"/scripts/* "$PACK"/hooks/*; do
  [ -f "$f" ] || continue
  hit="$(grep -nE '(rm +(-[a-zA-Z]+ +)*|rmSync\(|unlinkSync\(|rmdirSync\().*(/tmp|tmpdir\(\)|\$TMPDIR|\$\{TMPDIR)|readdirSync\((tmpdir|os\.tmpdir)' "$f" | grep -v '^[0-9]*: *//' || true)"
  [ -z "$hit" ] || BAD="$BAD$(basename "$f"): $hit"$'\n'
done
assert_equals "" "$BAD" "REQ-003 AC-2: no pack script removes a path in a shared temp folder"

print_summary
