#!/usr/bin/env bash
# Tests for feature 0000314-step-logs-stay-in-place, req-002: skills and
# standards name the driver files a step session leaves in place.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$(cat "$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md")"
INIT="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md")"
STD="$(awk '$0 == "#### Sessions and ack files" {on=1; next} on && /^#{1,4} / {exit} on {print}' "$ZERO_DIR/standards/roadmap-standards.md")"

echo "=== req-002 AC-1: both skills name the driver files ==="
for f in 'plan/.initiative-logs/' 'plan/.initiative-runner.lock' 'plan/.initiative-queue/'; do
  assert_contains "$f" "$ORCH" "req-002 AC-1: the orchestrator skill names $f"
  assert_contains "$f" "$INIT" "req-002 AC-1: the initiative skill names $f"
done
assert_contains "A step session never moves, renames, or deletes" "$ORCH" "req-002 AC-1: the orchestrator states the rule"
assert_contains "A step session never moves, renames, or deletes" "$INIT" "req-002 AC-1: the initiative skill states the rule"

echo ""
echo "=== req-002 AC-2: the standards name the rule ==="
for f in 'plan/.initiative-logs/' 'plan/.initiative-runner.lock' 'plan/.initiative-queue/'; do
  assert_contains "$f" "$STD" "req-002 AC-2: the standards name $f"
done
assert_contains "never moves, renames, or deletes" "$STD" "req-002 AC-2: the standards state the rule"

echo ""
echo "=== req-002 AC-3: size caps hold ==="
LINES=$(wc -l < "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" | tr -d ' ')
assert_equals "yes" "$([ "$LINES" -lt 120 ] && echo yes || echo no)" "req-002 AC-3: the initiative skill has fewer than 120 lines ($LINES)"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-002 AC-3: skill text is $TOTAL lines (cap 1720)"

print_summary
