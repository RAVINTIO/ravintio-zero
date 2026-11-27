#!/usr/bin/env bash
# Tests for feature 0000206-chart-time-decisions, req-002: a step applies a
# matching decision row, and the skills point to the rules.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
echo ""
echo "=== req-002 AC-1: a step applies a row ==="
assert_rule icrun-decision-row "## Decisions" "Decision applied (initiative chart): {fork}" "stops only for a fork no row covers" "missing table counts as an empty one"

echo ""
echo "=== req-002 AC-2: CI criteria wait for CI ==="
assert_rule icrun-ci-criterion "first CI run"

echo ""
echo "=== req-002 AC-3: the skills point to the rules ==="
assert_rule rm-ini-chart-intro "## Decisions"
assert_rule stops-decision-row-no-stop "## Decisions"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-002 AC-3: skill text $TOTAL <= 1720"

print_summary 2>/dev/null || true
