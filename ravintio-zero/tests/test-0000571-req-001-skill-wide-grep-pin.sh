#!/usr/bin/env bash
# Tests for feature 0000571-scan-cause-skill-wide-grep-pins, req-001:
# the Skill-text budget cause says to list suites that loop over every skill.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"

echo ""
echo "=== REQ-001 AC-1: the cause holds the skill-wide pin sentence ==="
assert_rule piv-cause-skill-text-budget "every skill" "file name, command, or flag" "List each match" "test-0000151-req-008-quiet-test-output.sh"

echo ""
echo "=== REQ-001 AC-2: the scan stays small ==="
SECTION=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")
SCAN=$(printf '%s\n' "$SECTION"; cat "$REF")
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "REQ-001 AC-2: the scan holds $LINES lines (cap 21)"

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
