#!/usr/bin/env bash
# Tests for feature 0000578-plan-lists-pass-signals, req-001:
# the plan skill lists every path to a pass signal, launcher failures included.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"

echo ""
echo "=== REQ-001 AC-1: the section holds the pass signal wording ==="
assert_rule piv-plan-pass-signal-when "exit code" "pass signal"
assert_rule plan-pass-signal-paths "pass signal" "each path" "launcher" "acceptance criterion"

echo ""
echo "=== REQ-001 AC-2: a launcher failure must fail the check ==="
assert_rule plan-pass-signal-paths "cannot run" "must fail the check"

echo ""
echo "=== REQ-001 AC-3: the skill stays within its caps and both trees match ==="
TOTAL=$(cat "$ZERO_DIR"/skills/*/SKILL.md | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "REQ-001 AC-3: skill text holds $TOTAL lines (cap 1720)"
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/SKILL.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "AC-3: $rel matches in both trees"
else
  assert_equals "same" "different" "AC-3: $rel matches in both trees"
fi

print_summary
