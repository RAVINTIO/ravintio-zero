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
assert_equals "| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |" "$STEPS_HEADER" "req-003 AC-1: the Steps header holds the Title column"

echo ""
echo "=== req-003 AC-2: the standard states which steps are skippable and the stop ==="
assert_rule rm-p1-skips-intro "## P1 skips"
assert_rule rm-p1-skips-bullets "chore with exact tasks" "change with no code"
assert_rule icrun-p1-skip "I-C Run: Blocked:" "no \`yes\` row"

echo ""
echo "=== req-003 AC-3: the build log names the chart row ==="
assert_rule icrun-p1-skipped-log "Skipped: P1" "chart row"
assert_rule rm-skip-protocol-initiative "no \`yes\` row" "chart row"

echo ""
echo "=== req-003: the initiative skill names the table ==="
assert_rule rm-ini-chart-intro "## P1 skips"

print_summary
