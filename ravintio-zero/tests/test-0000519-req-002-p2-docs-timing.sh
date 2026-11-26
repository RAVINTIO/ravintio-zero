#!/usr/bin/env bash
# Test: 0000519 req-002 P2 writes docs outside the full suite run
# The implement skill tells the agent to write docs before the full suite starts
# and to change no file until it ends.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"

echo ""
echo "=== req-002 AC-1: the rule orders docs and suite ==="
assert_rule implement-full-suite-once "one full suite run" "before P2 completes" "background" "write docs before" "change no file until"

echo ""
echo "=== req-002 AC-2: no text says to write docs while the suite runs ==="
WHILE=$(grep -iE 'while (you write docs|the full test suite runs)' "$IMPL" || true)
assert_equals "" "$WHILE" "req-002 AC-2: no docs-while-suite text"

echo ""
echo "=== req-002 AC-3: the caps hold ==="
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-002 AC-3: skill text $TOTAL <= 1720"

print_summary
