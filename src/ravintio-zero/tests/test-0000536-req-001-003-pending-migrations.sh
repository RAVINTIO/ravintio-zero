#!/usr/bin/env bash
# Tests for feature 0000536 REQ-001 to REQ-003: pending migrations reach the human at chart time.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="${ZERO_DIR:-$SCRIPT_DIR/..}"
SKILL="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
STD="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"
REF="$(cat "$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-resume-detection.md")"
MIG="$(cat "$ZERO_DIR/skills/ravintio-migrator/SKILL.md")"

echo "=== req-001: chart lists pending migrations ==="
assert_contains "### Chart-time migrations" "$STD" "AC-1: the standards hold the section"
assert_contains "rule: chart-migration-rows" "$STD" "AC-1: the section has a rule anchor"
assert_contains "Fork starts with \`Migration:\`" "$STD" "AC-1: the answer becomes a Migration row"
assert_contains "pending migration" "$SKILL" "AC-2: the skill names pending migrations at chart"
assert_contains "Chart-time migrations" "$SKILL" "AC-2: the skill points to the section"

echo "=== req-002: a step records and carries on ==="
assert_contains "rule: icrun-migration" "$STD" "AC-1: I-C Run holds the step rule"
assert_contains "Migration pending: {id}" "$STD" "AC-2: the standards name the log line"
assert_contains "Migration pending: {id}" "$REF" "AC-2: check 1 names the log line"
assert_contains "Pending migrations first.** Check \`ravintio-zero/migrations/\` for \`.md\` files not in \`_done/\`. If found, invoke \`ravintio-migrator\` for each before any other phase work." "$REF" "check 1 keeps its old line"
assert_contains "A step session never asks the human" "$REF" "AC-1: a step never asks"
assert_contains "Migration:" "$MIG" "AC-1: the migrator reads a chart row"
assert_not_contains "The answer is \`all\`" "$STD" "S-001: chart never offers all"
assert_contains "never holds \`all\`" "$STD" "S-001: a row lists each approved finding"
assert_contains "apply only the findings the row lists" "$STD" "S-001: a step applies listed findings only"
assert_contains "A row never approves \`all\`" "$MIG" "S-001: the migrator refuses all"

echo "=== req-003: the coordinator raises recorded migrations ==="
assert_contains "rule: coord-migration-raise" "$STD" "AC-1: the coordinator rule exists"
assert_not_contains "with the options \`all\` and \`none\`" "$STD" "S-001: the coordinator never offers all"
assert_contains "Migration pending:" "$SKILL" "AC-1: the skill reads the log line"

echo "=== caps ==="
LINES="$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "initiative skill has $LINES lines"

print_summary
