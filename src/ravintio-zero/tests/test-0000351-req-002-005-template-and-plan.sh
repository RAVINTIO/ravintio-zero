#!/usr/bin/env bash
# Tests for feature 0000351-step-titles-and-history-shape, req-002 and req-005.
#
# The initiative template charts a Title column. The plan skill carries the chart format rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TEMPLATE="$(cat "$SCRIPT_DIR/../templates/initiative.template.md")"

echo "=== req-002 AC-1: template has the Title column ==="
assert_contains "| Step | Feature id | Title | Backlog entries | Bump | Version | Status |" "$TEMPLATE" "req-002 AC-1: Steps header row has Title after Feature id"
assert_contains "Chart writes the title in sentence case" "$TEMPLATE" "req-002: note says Chart writes a sentence-case title"
assert_contains "P0, ship, and the history check read it" "$TEMPLATE" "req-002: note names the readers"

echo ""
echo "=== req-005 AC-1: plan skill carries the rule ==="
assert_rule ini-chart-format-update "plan/current-initiative/initiative.md" "chart format" "in the same step"
assert_rule ini-chart-format-unconvertible "file a backlog entry" "name the record in its PR"

print_summary
