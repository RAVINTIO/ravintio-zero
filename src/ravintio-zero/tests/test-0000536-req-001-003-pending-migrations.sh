#!/usr/bin/env bash
# Tests for feature 0000536 REQ-001 to REQ-003: pending migrations reach the human at chart time.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="${ZERO_DIR:-$SCRIPT_DIR/..}"
STD="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"

echo "=== req-001: chart lists pending migrations ==="
assert_contains "### Chart-time migrations" "$STD" "AC-1: the standards hold the section"
assert_rule chart-migration-rows "Fork starts with \`Migration:\`"
assert_rule rm-ini-chart-migrations "pending migration" "Chart-time migrations"

echo "=== req-002: a step records and carries on ==="
assert_rule icrun-migration "Migration pending: {id}" "apply only the findings the row lists"
assert_rule resume-migrations "Migration pending: {id}" "Pending migrations first" "ravintio-zero/migrations/" "_done/" "invoke \`ravintio-migrator\`" "A step session never asks the human"
assert_rule rm-migrator-chart-row "Migration:" "A row never approves \`all\`"
assert_not_contains "The answer is \`all\`" "$STD" "S-001: chart never offers all"
assert_rule chart-migration-rows "never holds \`all\`"

echo "=== req-003: the coordinator raises recorded migrations ==="
assert_rule coord-migration-raise "Migration pending:"
assert_not_contains "with the options \`all\` and \`none\`" "$STD" "S-001: the coordinator never offers all"
assert_rule rm-ini-report-parts "Migration pending:"

echo "=== caps ==="
LINES="$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "initiative skill has $LINES lines"

print_summary
