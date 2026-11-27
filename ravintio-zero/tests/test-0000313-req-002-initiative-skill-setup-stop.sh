#!/usr/bin/env bash
# Tests for feature 0000313-driver-setup-stop, req-002: the initiative skill treats a Setup:
# line as a planned stop and reruns setup before it starts a new driver.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
echo ""
echo "=== req-002: the Stops section holds the Setup: rule ==="
assert_rule ini-setup-stop "Setup:" "planned stop"
assert_rule ini-setup-command "Confirmation:"
assert_rule ini-setup-exact "exact command" "differs in any way"
assert_rule ini-setup-hooks ".claude/settings.json"
assert_rule ini-setup-restart "new driver" "watcher"
assert_rule ini-restart-setup "Restart: Setup:"

echo ""
echo "=== req-002: the skill stays under 120 lines ==="
LINES=$(wc -l < "$SKILL" | tr -d ' ')
if [ "$LINES" -lt 120 ]; then
  assert_contains "ok" "ok" "req-002: skill has $LINES lines"
else
  assert_contains "under 120" "$LINES lines" "req-002: skill has $LINES lines"
fi

print_summary
