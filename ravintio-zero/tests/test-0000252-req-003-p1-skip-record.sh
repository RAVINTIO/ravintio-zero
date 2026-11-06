#!/usr/bin/env bash
# Tests for feature 0000252-chart-rules, req-003: chart records whether each step may skip P1,
# and a step with no yes row stops when it would skip.
#
# AC-1: the template has the P1 skip field.
# AC-2: the standard states which steps are skippable and the stop.
# AC-3: the build log names the chart row.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"
TPL="$ZERO_DIR/templates/initiative.template.md"
SKIPREF="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-session-commands.md"

echo ""
echo "=== req-003 AC-1: the template has the P1 skip field ==="
C=$(grep -n '^## Criteria' "$TPL" | cut -d: -f1)
P=$(grep -n '^## P1 skips' "$TPL" | cut -d: -f1)
S=$(grep -n '^## Steps' "$TPL" | cut -d: -f1)
assert_equals "yes" "$([ -n "$C" ] && [ -n "$P" ] && [ -n "$S" ] && [ "$C" -lt "$P" ] && [ "$P" -lt "$S" ] && echo yes || echo no)" "req-003 AC-1: P1 skips sits between Criteria and Steps"
PSEC=$(awk '/^## P1 skips/{f=1;next} /^## /{f=0} f' "$TPL")
assert_contains "| Step | Skip P1 | Reason |" "$PSEC" "req-003 AC-1: the table has a step, a yes or no, and a reason"
STEPS_HEADER=$(grep -m1 '^| Step | Feature id' "$TPL")
assert_equals "| Step | Feature id | Title | Backlog entries | Bump | Version | Status |" "$STEPS_HEADER" "req-003 AC-1: the Steps header holds the Title column"

echo ""
echo "=== req-003 AC-2: the standard states which steps are skippable and the stop ==="
CHART=$(awk '/^### I-A Chart/{f=1} /^### I-B Activate/{f=0} f' "$STANDARDS")
assert_contains "## P1 skips" "$CHART" "req-003 AC-2: Chart names the P1 skips table"
assert_contains "chore with exact tasks" "$CHART" "req-003 AC-2: a chore with exact tasks may be yes"
assert_contains "change with no code" "$CHART" "req-003 AC-2: a change with no code may be yes"
RUN=$(awk '/^### I-C Run/{f=1;next} /^### /{f=0} f' "$STANDARDS")
assert_contains "I-C Run: Blocked:" "$RUN" "req-003 AC-2: I-C Run holds the Blocked stop"
assert_contains "no \`yes\` row" "$RUN" "req-003 AC-2: the stop names a step with no yes row"

echo ""
echo "=== req-003 AC-3: the build log names the chart row ==="
assert_contains "Skipped: P1" "$RUN" "req-003 AC-3: I-C Run holds the Skipped: P1 line"
assert_contains "chart row" "$RUN" "req-003 AC-3: the line names the chart row"
SKIPTXT=$(cat "$SKIPREF")
assert_contains "no \`yes\` row" "$SKIPTXT" "req-003 AC-3: the Phase Skip Protocol names the stop"
assert_contains "chart row" "$SKIPTXT" "req-003 AC-3: the Phase Skip Protocol names the chart row"

echo ""
echo "=== req-003: the initiative skill names the table ==="
SKILL_CHART=$(awk '/^## I-A Chart and I-B Activate/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "## P1 skips" "$SKILL_CHART" "req-003: the skill names the P1 skips table"

print_summary
