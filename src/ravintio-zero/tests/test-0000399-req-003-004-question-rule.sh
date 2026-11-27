#!/usr/bin/env bash
# Tests for feature 0000399 REQ-003 and REQ-004: the initiative skill's question rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="${ZERO_DIR:-$SCRIPT_DIR/..}"

echo "=== req-003: restate, default, confirm ==="
assert_rule rm-ini-questions "Restate the human's words as one concrete plan" "name the default" '"Go?"' "Offer other options only for a real fork"

echo "=== req-004: one question per reply ==="
assert_rule rm-ini-questions "Ask at most one question per reply" "Never ask about what the human already said"

echo "=== the standards hold the rules and commands ==="
assert_rule coord-question-form 'Go?'
assert_rule coord-one-question 'One question per reply'
assert_rule coord-activate-command 'initiative-activate.mjs'
assert_rule coord-add-step 'initiative-add-step.mjs'
assert_rule coord-plan-only-pr 'coordinator-pr-check.mjs'
assert_rule coord-startup-skill 'initiative skill'
assert_rule rm-ini-questions "initiative-activate.mjs" "initiative-add-step.mjs" "coordinator-pr-check.mjs"

echo "=== 0000554: a defined stage starts without a question ==="
assert_rule coord-defined-stage "starts it and reports the start as a status" "asks only at a real fork or before a human-only action"
assert_rule rm-ini-session-delivery "Start I-E Delivery with no question after the driver's clean end"

echo "=== the skill stays under 120 lines ==="
LINES="$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')"
assert_equals "ok" "$([ "$LINES" -lt 120 ] && echo ok || echo long)" "skill has $LINES lines"

print_summary
