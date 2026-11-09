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
CHART=$(awk '/^### I-A Chart/{f=1} /^### I-B Activate/{f=0} f' "$STANDARDS")
assert_contains "confirmation that a step's skills ask for" "$CHART" "req-002 AC-1: chart lists each confirmation"
assert_contains "exact command" "$CHART" "req-002 AC-1: the pre-approval holds the exact command"
assert_contains "human stop" "$CHART" "req-002 AC-1: chart can plan a human stop"
assert_contains "\`Confirmation:\`" "$CHART" "req-002 AC-1: the rule names the Confirmation: row form"

echo ""
echo "=== req-002 AC-2: the template has a confirmation row form ==="
DEC=$(awk '/^## Decisions/{f=1;next} /^## /{f=0} f' "$TPL")
assert_contains "| Confirmation:" "$DEC" "req-002 AC-2: a Decisions row starts with Confirmation:"
assert_contains "exact command" "$DEC" "req-002 AC-2: the row form holds the exact command"

echo ""
echo "=== req-002 AC-3: a pre-approved confirmation does not stop a step ==="
RUN=$(awk '/^### I-C Run/{f=1;next} /^### /{f=0} f' "$STANDARDS")
assert_contains "\`Confirmation:\` row" "$RUN" "req-002 AC-3: I-C Run names the Confirmation: row"
assert_contains "no stop" "$RUN" "req-002 AC-3: a matching row gives no stop"
assert_contains "differs in any way" "$RUN" "req-002 AC-3: a differing command stops the step"

echo ""
echo "=== req-002: the initiative skill holds the rule ==="
SKILL_CHART=$(awk '/^## I-A Chart and I-B Activate/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "step confirmation" "$SKILL_CHART" "req-002: the skill names the step confirmation"

print_summary
