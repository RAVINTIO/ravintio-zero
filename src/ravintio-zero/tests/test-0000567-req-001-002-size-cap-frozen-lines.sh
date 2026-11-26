#!/usr/bin/env bash
# Tests for feature 0000567-test-impact-size-caps-and-frozen-lines, req-001 and req-002:
# the Size cap cause lists every cap and the Reference file edit cause names the frozen-line check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"

echo ""
echo "=== REQ-001 AC-1 and AC-2: the Size cap cause lists every cap and plans against the lowest ==="
assert_rule piv-cause-size-cap "List every test that measures the skill" "each cap value" "not the first match" "lowest cap"

echo ""
echo "=== REQ-002 AC-1 and AC-2: the Reference file edit cause names the frozen-line check ==="
assert_rule piv-cause-reference-edit "test-0000151-req-011-orchestrator-references-split.sh" "every base line" "boot template" "read the cap from the suite"

echo ""
echo "=== REQ-002 AC-3: the scan stays within 21 lines ==="
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN"; cat "$REF")
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "REQ-002 AC-3: the scan holds $LINES lines (cap 21)"

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
