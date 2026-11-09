#!/usr/bin/env bash
# Tests for feature 0000351-step-titles-and-history-shape, req-002 and req-005.
#
# The initiative template charts a Title column. The plan skill carries the chart format rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TEMPLATE="$(cat "$SCRIPT_DIR/../templates/initiative.template.md")"
PLAN="$(cat "$SCRIPT_DIR/../skills/ravintio-plan/SKILL.md")"

echo "=== req-002 AC-1: template has the Title column ==="
assert_contains "| Step | Feature id | Title | Backlog entries | Bump | Version | Status |" "$TEMPLATE" "req-002 AC-1: Steps header row has Title after Feature id"
assert_contains "Chart writes the title in sentence case" "$TEMPLATE" "req-002: note says Chart writes a sentence-case title"
assert_contains "P0, ship, and the history check read it" "$TEMPLATE" "req-002: note names the readers"

echo ""
echo "=== req-005 AC-1: plan skill carries the rule ==="
assert_contains "plan/current-initiative/initiative.md" "$PLAN" "req-005 AC-1: names the active chart"
assert_contains "changes a chart format" "$PLAN" "req-005 AC-1: covers a chart format change"
assert_contains "in the same step" "$PLAN" "req-005 AC-1: update lands in the same step"
assert_contains "file a backlog entry" "$PLAN" "req-005 AC-1: files an entry for an unconvertible record"
assert_contains "name the record in its PR" "$PLAN" "req-005 AC-1: names the record in the PR"

print_summary
