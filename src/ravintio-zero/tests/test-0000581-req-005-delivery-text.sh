#!/usr/bin/env bash
# 0000581 req-005: I-E Delivery, the final report, and the initiative skill name the cleanup.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"

echo "=== req-005 AC-1: the standard names the cleanup ==="
assert_rule rm-delivery-cleanup 'initiative-cleanup.mjs' 'plan/.initiative-runner.lock' '.git/ravintio-archive/' 'plan/.initiative-queue/' 'the human merges the PR'

echo "=== req-005 AC-2: the skill names the cleanup and stays short ==="
assert_rule rm-ini-delivery 'initiative-cleanup.mjs'
assert_contains "initiative-cleanup.mjs" "$(cat "$SKILL")" "AC-2: the final report names the script"
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "AC-2: initiative skill stays under 120 lines ($LINES)"

print_summary
