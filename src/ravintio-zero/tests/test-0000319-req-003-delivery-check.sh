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


echo "=== req-003 AC-1: the delivery step ==="
assert_rule rm-delivery-history-check 'node ravintio-zero/scripts/check-initiative-history.mjs' 'failing commit' 'PR body' 'stop'

echo ""
echo "=== req-003 AC-2: the title and body ==="
assert_rule rm-delivery-pr-title 'PR title' 'merge commit'
assert_rule rm-delivery-pr-body 'first line of the body' 'merge commit'

echo ""
echo "=== req-003: the skill points to the standards ==="
assert_rule rm-ini-delivery 'history'
SKILL_LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$SKILL_LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "req-003: initiative skill stays under 120 lines"

print_summary
