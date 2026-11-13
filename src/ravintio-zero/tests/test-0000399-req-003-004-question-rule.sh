#!/usr/bin/env bash
# Tests for feature 0000399 REQ-003 and REQ-004: the initiative skill's question rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="${ZERO_DIR:-$SCRIPT_DIR/..}"
SKILL="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
STD="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"

echo "=== req-003: restate, default, confirm ==="
assert_contains "Restate the human's words as one concrete plan" "$SKILL" "AC-1: skill names the restate step"
assert_contains "name the default" "$SKILL" "AC-1: skill names the default"
assert_contains '"Go?"' "$SKILL" "AC-1: skill names the confirm"
assert_contains "Offer other options only for a real fork" "$SKILL" "AC-2: other options only for a real fork"

echo "=== req-004: one question per reply ==="
assert_contains "Ask at most one question per reply" "$SKILL" "AC-1: at most one question"
assert_contains "Never ask about what the human already said" "$SKILL" "AC-2: never re-ask"

echo "=== the standards hold the rules and commands ==="
for r in coord-question-form coord-one-question coord-activate-command coord-add-step coord-plan-only-pr coord-startup-skill; do
  assert_contains "rule: $r" "$STD" "standards anchor $r"
done
assert_contains "initiative-activate.mjs" "$SKILL" "skill names the activate command"
assert_contains "initiative-add-step.mjs" "$SKILL" "skill names add-step"
assert_contains "coordinator-pr-check.mjs" "$SKILL" "skill names the plan-only check"

echo "=== the skill stays under 120 lines ==="
LINES="$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "skill has $LINES lines"

print_summary
