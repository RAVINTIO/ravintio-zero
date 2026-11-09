#!/usr/bin/env bash
# Tests for feature 0000384: plan and ship skill text for checks and the ADR home.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$(cat "$ZERO_DIR/skills/ravintio-plan/SKILL.md")"
SHIP="$(cat "$ZERO_DIR/skills/ravintio-ship/SKILL.md")"

echo ""
echo "=== plan skill ==="
assert_contains 'Oldest shell: {shell and version}' "$PLAN" "plan names the oldest shell line"
assert_contains 'Check 9 enforces it' "$PLAN" "plan ties the line to check 9"
assert_contains 'docs/adr/{NNNN}-{slug}.md' "$PLAN" "plan writes ADRs to docs/adr"
assert_contains 'status `proposed`' "$PLAN" "plan sets status proposed"
assert_contains 'reserve-id.mjs --file docs/adr/.next-id' "$PLAN" "plan reserves ADR numbers"
assert_contains 'Commit the counter on its own' "$PLAN" "plan commits the counter alone"
assert_contains 'Superseded by {number}' "$PLAN" "plan marks superseded ADRs"
assert_contains 'Nobody deletes an ADR' "$PLAN" "plan bans ADR deletion"
assert_contains '`Shared resources` column' "$PLAN" "plan has the Shared resources rule"
assert_contains 'living docs unit' "$PLAN" "plan has the living docs unit"
assert_contains 'Check 10 requires it' "$PLAN" "plan ties the unit to check 10"
assert_contains 'human-settings-check.mjs' "$PLAN" "plan runs the human settings check"
assert_contains 'stop before P2' "$PLAN" "plan stops before P2 on exit 1"
assert_not_contains 'plan/current/adr/ADR-' "$PLAN" "plan drops the old ADR path"

echo ""
echo "=== ship skill ==="
assert_contains 'status `accepted`' "$SHIP" "ship accepts ADRs"
assert_contains 'docs/decisions-index.md' "$SHIP" "ship adds index rows"
assert_contains 'links to `docs/adr/` and holds no copy' "$SHIP" "archive links to docs/adr"

echo ""
echo "=== size ==="
TOTAL=$(cat "$ZERO_DIR"/skills/*/SKILL.md | wc -l | tr -d ' ')
if [ "$TOTAL" -le 1720 ]; then assert_contains ok ok "SKILL.md total $TOTAL <= 1720"; else assert_contains ok "$TOTAL" "SKILL.md total $TOTAL <= 1720"; fi

print_summary 2>/dev/null || true
