#!/usr/bin/env bash
# Tests for feature 0000567-test-impact-size-caps-and-frozen-lines, req-001 and req-002:
# the Size cap cause lists every cap and the Reference file edit cause names the frozen-line check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
SIZE=$(grep -F '**Size cap:**' "$REF" 2>/dev/null || true)
REFEDIT=$(grep -F '**Reference file edit:**' "$REF" 2>/dev/null || true)

echo ""
echo "=== REQ-001 AC-1: the Size cap cause lists every cap ==="
assert_contains "List every test that measures the skill" "$SIZE" "REQ-001 AC-1: the cause asks for every test"
assert_contains "each cap value" "$SIZE" "REQ-001 AC-1: the cause asks for each cap value"
assert_contains "not the first match" "$SIZE" "REQ-001 AC-1: the cause rejects the first match"

echo ""
echo "=== REQ-001 AC-2: the cause plans against the lowest cap ==="
assert_contains "lowest cap" "$SIZE" "REQ-001 AC-2: the cause names the lowest cap"

echo ""
echo "=== REQ-002 AC-1 and AC-2: the Reference file edit cause names the frozen-line check ==="
assert_contains "test-0000151-req-011-orchestrator-references-split.sh" "$REFEDIT" "REQ-002 AC-1: the cause names the suite"
assert_contains "every base line" "$REFEDIT" "REQ-002 AC-2: the cause names the frozen base lines"
assert_contains "boot template" "$REFEDIT" "REQ-002 AC-2: the cause names the boot template cap"
assert_contains "read the cap from the suite" "$REFEDIT" "REQ-002 AC-2: the cause sends the reader to the suite for the number"

echo ""
echo "=== REQ-002 AC-3: the scan stays within 20 lines ==="
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN"; cat "$REF")
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 20 ] && echo yes || echo no)" "REQ-002 AC-3: the scan holds $LINES lines (cap 20)"

echo ""
echo "=== AC-3 and NFR-001: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/references/test-impact-causes.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "AC-3: $rel matches in both trees"
else
  assert_equals "same" "different" "AC-3: $rel matches in both trees"
fi

print_summary
