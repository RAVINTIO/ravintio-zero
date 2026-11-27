#!/usr/bin/env bash
# Tests for feature 0000568-wording-pin-scan, req-001:
# the test impact scan has a Prose rewrite cause that greps the tests for each changed sentence.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"

echo ""
echo "=== REQ-001 AC-1 and AC-2: the cause greps the tests for each changed sentence and lists matches ==="
assert_rule piv-cause-prose-rewrite "ravintio-zero/tests/" "each changed sentence" "execution plan"

echo ""
echo "=== REQ-001 AC-3: the scan names the cause ==="
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN"; cat "$REF")
assert_rule piv-cause-prose-rewrite "Prose rewrite"

echo ""
echo "=== REQ-001 AC-4: the scan stays within 21 lines ==="
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "REQ-001 AC-4: the scan holds $LINES lines (cap 21)"

echo ""
echo "=== REQ-001 AC-5: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/references/test-impact-causes.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "AC-5: $rel matches in both trees"
else
  assert_equals "same" "different" "AC-5: $rel matches in both trees"
fi

print_summary
