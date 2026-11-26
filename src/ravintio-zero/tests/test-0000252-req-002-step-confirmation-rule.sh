#!/usr/bin/env bash
# Tests for feature 0000252-chart-rules, req-002: chart lists each confirmation that a step's
# skills ask for and records a pre-approval or plans a human stop.
#
# AC-1: the standard holds the confirmation rule.
# AC-2: the template has a confirmation row form.
# AC-3: a pre-approved confirmation does not stop a step.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"
TPL="$ZERO_DIR/templates/initiative.template.md"

echo ""
echo "=== req-002 AC-1: the standard holds the confirmation rule ==="
assert_rule rm-confirmations-steps "confirmation that a step's skills ask for" "exact command" "human stop" "\`Confirmation:\`"

echo ""
echo "=== req-002 AC-2: the template has a confirmation row form ==="
DEC=$(awk '/^## Decisions/{f=1;next} /^## /{f=0} f' "$TPL")
assert_contains "| Confirmation:" "$DEC" "req-002 AC-2: a Decisions row starts with Confirmation:"
assert_contains "exact command" "$DEC" "req-002 AC-2: the row form holds the exact command"

echo ""
echo "=== req-002 AC-3: a pre-approved confirmation does not stop a step ==="
assert_rule icrun-confirmation "\`Confirmation:\` row" "no stop" "differs in any way"

echo ""
echo "=== req-002: the initiative skill holds the rule ==="
assert_rule rm-ini-confirmation "step confirmation"

print_summary
