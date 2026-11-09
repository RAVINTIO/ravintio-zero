#!/usr/bin/env bash
# Tests for feature 0000319-initiative-history-checks, req-003.
#
# I-E Delivery runs the history script and puts the merge commit instruction in the PR.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/roadmap-standards.md"
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"

DELIVERY="$(awk '$0 == "### I-E Delivery" {on=1; next} on && /^###? / {exit} on {print}' "$STD")"
SKILL_TEXT="$(cat "$SKILL")"
SKILL_DELIVERY="$(awk '$0 == "## I-E Delivery" {on=1; next} on && /^## / {exit} on {print}' "$SKILL")"

echo "=== req-003 AC-1: the delivery step ==="
assert_contains 'node ravintio-zero/scripts/check-initiative-history.mjs' "$DELIVERY" "req-003 AC-1: names the script"
assert_contains 'failing commit' "$DELIVERY" "req-003 AC-1: names the failing commits"
assert_contains 'PR body' "$DELIVERY" "req-003 AC-1: lists them in the PR body"
assert_contains 'stop' "$DELIVERY" "req-003 AC-1: names the stop"

echo ""
echo "=== req-003 AC-2: the title and body ==="
assert_contains 'PR title' "$DELIVERY" "req-003 AC-2: names the PR title"
assert_contains 'first line of the body' "$DELIVERY" "req-003 AC-2: names the first body line"
assert_contains 'merge commit' "$DELIVERY" "req-003 AC-2: names the merge commit instruction"

echo ""
echo "=== req-003: the skill points to the standards ==="
assert_contains 'history' "$SKILL_DELIVERY" "req-003: skill delivery section names the history check"
SKILL_LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$SKILL_LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "req-003: initiative skill stays under 120 lines"

print_summary
