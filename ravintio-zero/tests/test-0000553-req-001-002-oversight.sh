#!/usr/bin/env bash
# Tests for feature 0000553-coordinator-oversight-not-micromanagement, req-001 and req-002.
#
# The initiative skill relays watcher lines only at phase events, blocks, and stops.
# It reads step test output only after a stop.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SKILL_FILE="$SCRIPT_DIR/../skills/ravintio-initiative/SKILL.md"
REPORTS="$(rule_text ini-report-cadence)
$(rule_text ini-relay-events)"

echo ""
echo "=== req-001: relay only at phase events, blocks, and stops ==="
assert_rule ini-relay-events "only at phase events, blocks, and stops"
assert_not_contains "Relay each one" "$REPORTS" "req-001 AC-1: no instruction to relay each activity line"
assert_not_contains "Relay each activity" "$REPORTS" "req-001 AC-1: no instruction to relay each activity line (alt)"
assert_rule ini-status-before-report "I-C Run: event:"

echo ""
echo "=== req-002: step test output only after a stop ==="
assert_rule ini-relay-events "step test output only after a stop"
LINES="$(wc -l < "$SKILL_FILE" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "req-002 AC-2: the skill has $LINES lines"

print_summary
