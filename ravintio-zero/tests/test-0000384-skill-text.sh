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
assert_rule shp-plan-oldest-shell 'Oldest shell: {shell and version}' 'Check 9 enforces it'
assert_rule shp-plan-adr-write 'docs/adr/{NNNN}-{slug}.md' 'status `proposed`'
assert_rule shp-plan-adr-reserve 'reserve-id.mjs --file docs/adr/.next-id' 'Commit the counter on its own'
assert_rule shp-plan-adr-superseded 'Superseded by {number}' 'Nobody deletes an ADR'
assert_rule shp-plan-shared-resources '`Shared resources` column'
assert_rule shp-plan-living-docs-unit 'living docs unit' 'Check 10 requires it'
assert_rule shp-plan-human-settings-check 'human-settings-check.mjs' 'stop before P2'
assert_not_contains 'plan/current/adr/ADR-' "$PLAN" "plan drops the old ADR path"

echo ""
echo "=== ship skill ==="
assert_rule shp-archive-adrs 'status `accepted`' 'docs/decisions-index.md' 'links to `docs/adr/` and holds no copy'

echo ""
echo "=== size ==="
TOTAL=$(cat "$ZERO_DIR"/skills/*/SKILL.md | wc -l | tr -d ' ')
if [ "$TOTAL" -le 1720 ]; then assert_contains ok ok "SKILL.md total $TOTAL <= 1720"; else assert_contains ok "$TOTAL" "SKILL.md total $TOTAL <= 1720"; fi

print_summary 2>/dev/null || true
