#!/usr/bin/env bash
# Tests for feature 0000499-reply-times-match-clock, req-002: the clock rule text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$(cat "$ZERO_DIR/pipeline-reference.md")"

echo ""
echo "=== AC-1: the standards state the rule ==="
assert_rule rm-reply-time-source "clock read" "estimate" "date +%H:%M" "clock hook"

echo ""
echo "=== AC-2: the skill and the reference repeat it ==="
assert_rule rm-ini-prefix "clock hook" "date +%H:%M"
assert_contains "clock hook" "$REF" "AC-2: the pipeline reference names the clock hook"
assert_contains "date +%H:%M" "$REF" "AC-2: the pipeline reference names the date command"

echo ""
echo "=== AC-3: the orchestrator stays under its cap ==="
SIZE=$(strip_rule_anchors < "$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md" | wc -c | tr -d ' ')  # anchors are comments, so the cap measures the text without them
if [ "$SIZE" -le 9000 ]; then assert_equals "ok" "ok" "AC-3: $SIZE bytes"; else assert_equals "9000 or fewer" "$SIZE" "AC-3: size"; fi

print_summary
