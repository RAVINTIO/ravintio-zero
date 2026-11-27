#!/usr/bin/env bash
# Tests for feature 0000206-chart-time-decisions, req-001 and req-003: the
# Chart-time decisions rules, the template tables, and the worked example.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/roadmap-standards.md"
TPL="$ZERO_DIR/templates/initiative.template.md"


echo ""
echo "=== req-001 AC-1: the standards state the rules ==="
assert_equals "1" "$(grep -c '^### Chart-time decisions' "$STD")" "req-001 AC-1: the section exists"
assert_rule rm-decisions-steps "Pre-mortem" "Baseline" "Criterion critic" "fallback" "Bump rule" "Environment check" "Retrospective" "plan/retrospectives/"

echo ""
echo "=== req-001 AC-2: the template holds the tables ==="
D=$(grep -n '^## Dependencies' "$TPL" | cut -d: -f1)
DE=$(grep -n '^## Decisions' "$TPL" | cut -d: -f1)
B=$(grep -n '^## Baselines' "$TPL" | cut -d: -f1)
C=$(grep -n '^## Criteria' "$TPL" | cut -d: -f1)
S=$(grep -n '^## Steps' "$TPL" | cut -d: -f1)
assert_equals "yes" "$([ -n "$DE" ] && [ -n "$B" ] && [ -n "$C" ] && [ -n "$S" ] && [ "$D" -lt "$DE" ] && [ "$DE" -lt "$B" ] && [ "$B" -lt "$C" ] && [ "$C" -lt "$S" ] && echo yes || echo no)" "req-001 AC-2: Decisions, Baselines, Criteria sit between Dependencies and Steps"

echo ""
echo "=== req-001 AC-3: Chart names the tables ==="
assert_rule rm-chart-also "## Decisions" "## Baselines" "## Criteria"

echo ""
echo "=== req-003 AC-1: the worked example answers the four stops ==="
assert_rule rm-decisions-example "Profile on Windows" "drop skill bundling" "Raise the bump" "Measure per case"

print_summary 2>/dev/null || true
