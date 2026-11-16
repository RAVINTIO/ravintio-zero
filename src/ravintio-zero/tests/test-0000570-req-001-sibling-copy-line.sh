#!/usr/bin/env bash
# Tests for feature 0000570-sibling-test-copies-in-impact-scan, req-001:
# the test impact scan says to list the regression copy of each test it names.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
SECTION=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")

echo ""
echo "=== REQ-001 AC-1: the scan holds the sibling-copy line ==="
assert_contains "tests/regression/" "$SECTION" "REQ-001 AC-1: the scan names the regression folder"
assert_contains "same name" "$SECTION" "REQ-001 AC-1: the scan says to grep for the same file name"
assert_contains "list the match" "$SECTION" "REQ-001 AC-1: the scan says to list the match"

echo ""
echo "=== REQ-001 AC-2: the scan stays small ==="
SCAN=$(printf '%s\n' "$SECTION"; cat "$REF")
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "REQ-001 AC-2: the scan holds $LINES lines (cap 21)"

echo ""
echo "=== REQ-001 AC-3: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/SKILL.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "AC-3: $rel matches in both trees"
else
  assert_equals "same" "different" "AC-3: $rel matches in both trees"
fi

print_summary
