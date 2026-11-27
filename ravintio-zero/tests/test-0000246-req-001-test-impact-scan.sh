#!/usr/bin/env bash
# Tests for feature 0000246-plan-checks-count-and-cap-tests, req-001: the plan
# skill holds a Test impact scan section and the execution plan template holds
# a Test impact section.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
TEMPLATE="$ZERO_DIR/templates/execution-plan.template.md"

echo ""
echo "=== req-001 AC-1: the plan skill carries the scan ==="
SECTION_TEXT=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")
assert_rule piv-cause-skill-count "Skill count"
assert_rule piv-cause-skill-text-budget "Skill-text budget"
assert_rule piv-cause-size-cap "Size cap"
assert_rule piv-cause-backlog-id "Backlog entry id"
assert_rule piv-plan-impact-scan "ravintio-zero/tests/"
assert_rule piv-plan-impact-none-found "none found"

echo ""
echo "=== req-001 AC-2: the template carries the section ==="
assert_rule piv-template-test-impact-table "| Cause | Test | Unit |"
IMPACT_LINE=$(grep -n '^## Test impact' "$TEMPLATE" | head -1 | cut -d: -f1)
CONC_LINE=$(grep -n '^## Concurrency plan' "$TEMPLATE" | head -1 | cut -d: -f1)
ORDER=$([ -n "${IMPACT_LINE:-}" ] && [ -n "${CONC_LINE:-}" ] && [ "$IMPACT_LINE" -lt "$CONC_LINE" ] && echo before || echo other)
assert_equals "before" "$ORDER" "req-001 AC-2: the section sits before the Concurrency plan"

echo ""
echo "=== req-001 AC-3: the scan stays small ==="
LINES=$(printf '%s\n' "$SECTION_TEXT" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -gt 0 ] && [ "$LINES" -le 15 ] && echo yes || echo no)" "req-001 AC-3: the scan holds 1 to 15 lines ($LINES)"

print_summary
