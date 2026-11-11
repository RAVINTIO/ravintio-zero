#!/usr/bin/env bash
# Tests for feature 0000499-reply-times-match-clock, req-002: the clock rule text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STANDARDS="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"
INIT="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
REF="$(cat "$ZERO_DIR/pipeline-reference.md")"

echo ""
echo "=== AC-1: the standards state the rule ==="
RULE="$(printf '%s\n' "$STANDARDS" | grep -A6 'rule: reply-time-form')"
assert_contains "clock read" "$RULE" "AC-1: the rule names a clock read"
assert_contains "estimate" "$RULE" "AC-1: the rule bans an estimate"
assert_contains "date +%H:%M" "$RULE" "AC-1: the rule names the date command"
assert_contains "clock hook" "$RULE" "AC-1: the rule names the clock hook"

echo ""
echo "=== AC-2: the skill and the reference repeat it ==="
assert_contains "clock hook" "$INIT" "AC-2: the initiative skill names the clock hook"
assert_contains "date +%H:%M" "$INIT" "AC-2: the initiative skill names the date command"
assert_contains "clock hook" "$REF" "AC-2: the pipeline reference names the clock hook"
assert_contains "date +%H:%M" "$REF" "AC-2: the pipeline reference names the date command"

echo ""
echo "=== AC-3: the orchestrator stays under its cap ==="
SIZE=$(wc -c < "$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md" | tr -d ' ')
if [ "$SIZE" -le 9000 ]; then assert_equals "ok" "ok" "AC-3: $SIZE bytes"; else assert_equals "9000 or fewer" "$SIZE" "AC-3: size"; fi

print_summary
