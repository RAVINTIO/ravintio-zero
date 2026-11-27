#!/usr/bin/env bash
# Tests for feature 0000577-plan-lists-change-shapes, req-001:
# the Diff reader cause says to name a test world for add, rename, and delete.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
CAUSE=$(grep -F '**Diff reader:**' "$REF" || true)

echo ""
echo "=== REQ-001 AC-1: the cause holds the change shape wording ==="
assert_contains "git diff" "$CAUSE" "REQ-001 AC-1: the cause names a git diff"
assert_contains "file list" "$CAUSE" "REQ-001 AC-1: the cause names a file list"
assert_contains "test world" "$CAUSE" "REQ-001 AC-1: the cause names a test world"
assert_contains "add, rename, and delete" "$CAUSE" "REQ-001 AC-1: the cause names the three change shapes"
assert_contains "lists a rename apart from an add" "$CAUSE" "REQ-001 AC-1: the cause says why a rename needs its own world"

echo ""
echo "=== REQ-001 AC-2: the scan stays small and both earlier causes remain ==="
SECTION=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")
SCAN=$(printf '%s\n' "$SECTION"; cat "$REF")
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "REQ-001 AC-2: the scan holds $LINES lines (cap 21)"
assert_contains "**New test file:**" "$SCAN" "REQ-001 AC-2: the scan still names New test file"
assert_contains "**Non-suite file:**" "$SCAN" "REQ-001 AC-2: the scan still names Non-suite file"

echo ""
echo "=== REQ-001 AC-3: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/references/test-impact-causes.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "AC-3: $rel matches in both trees"
else
  assert_equals "same" "different" "AC-3: $rel matches in both trees"
fi

print_summary
