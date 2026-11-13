#!/usr/bin/env bash
# Tests for feature 0000521-replies-name-actors-by-role, REQ-001 and REQ-003:
# the conventions name actors by role, and the report heading follows the rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
RULE="names each actor by role"
BAR='never uses "I" or "you"'

echo ""
echo "=== req-001 AC-1: the boot templates hold the rule ==="
for f in standard-boot.md codex-boot.md; do
  SECTION=$(awk '/^## Reply Conventions/{f=1;next} /^## /{f=0} f' "$ZERO_DIR/templates/$f")
  assert_contains "$RULE" "$SECTION" "req-001 AC-1: $f names actors by role"
  assert_contains "$BAR" "$SECTION" "req-001 AC-1: $f bars I and you"
done

echo ""
echo "=== req-001 AC-2: the skill and the standards hold the rule ==="
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
assert_contains "$RULE" "$(cat "$ORCH")" "req-001 AC-2: the orchestrator names actors by role"
assert_contains "$BAR" "$(cat "$ORCH")" "req-001 AC-2: the orchestrator bars I and you"
STANDARDS="$(cat "$ZERO_DIR/standards/roadmap-standards.md")"
assert_contains "$RULE" "$STANDARDS" "req-001 AC-2: the roadmap standards name actors by role"
assert_contains "$BAR" "$STANDARDS" "req-001 AC-2: the roadmap standards bar I and you"

echo ""
echo "=== req-001 AC-3: the orchestrator skill stays under its cap ==="
BYTES=$(wc -c < "$ORCH" | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator SKILL.md holds $BYTES bytes (cap 9000)"

echo ""
echo "=== req-003 AC-1: the report heading follows the rule ==="
SKILL="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
assert_contains "Decisions for the human" "$SKILL" "req-003 AC-1: the skill uses the new heading"
assert_not_contains "Decisions for you" "$SKILL" "req-003 AC-1: the skill drops the old heading"
assert_contains "Decisions for the human" "$STANDARDS" "req-003 AC-1: the standards use the new heading"
assert_not_contains "Decisions for you" "$STANDARDS" "req-003 AC-1: the standards drop the old heading"

print_summary
