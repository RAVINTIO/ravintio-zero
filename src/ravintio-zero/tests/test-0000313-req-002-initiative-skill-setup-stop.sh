#!/usr/bin/env bash
# Tests for feature 0000313-driver-setup-stop, req-002: the initiative skill treats a Setup:
# line as a planned stop and reruns setup before it starts a new driver.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
STOPS=$(awk '/^## Stops/{f=1;next} /^## /{f=0} f' "$SKILL")

echo ""
echo "=== req-002: the Stops section holds the Setup: rule ==="
assert_contains "Setup:" "$STOPS" "req-002: the Stops section names the Setup: line"
assert_contains "planned stop" "$STOPS" "req-002: a Setup: line is a planned stop"
assert_contains "Confirmation:" "$STOPS" "req-002: the setup command comes from the Confirmation: row"
assert_contains "exact command" "$STOPS" "req-002: the skill runs the exact command"
assert_contains "differs in any way" "$STOPS" "req-002: a differing command stops for the human"
assert_contains ".claude/settings.json" "$STOPS" "req-002: the skill checks the hooks in settings.json"
assert_contains "new driver" "$STOPS" "req-002: the skill starts a new driver"
assert_contains "watcher" "$STOPS" "req-002: the skill starts a new watcher"
assert_contains "Restart: Setup:" "$STOPS" "req-002: the skill handles a combined Restart: Setup: line"

echo ""
echo "=== req-002: the skill stays under 120 lines ==="
LINES=$(wc -l < "$SKILL" | tr -d ' ')
if [ "$LINES" -lt 120 ]; then
  assert_contains "ok" "ok" "req-002: skill has $LINES lines"
else
  assert_contains "under 120" "$LINES lines" "req-002: skill has $LINES lines"
fi

print_summary
