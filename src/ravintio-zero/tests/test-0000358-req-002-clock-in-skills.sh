#!/usr/bin/env bash
# Test: 0000358 req-002 and req-004 clock-in-skills
# Five skills tell the phase to read every logged time from the clock, and the
# validate skill points at the failed suite list.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILLS="$ZERO_DIR/skills"
CMD='date -u +%Y-%m-%dT%H:%M:%SZ'

echo ""
echo "=== req-002 AC-1: each skill names the clock command ==="
for s in ravintio-orchestrator ravintio-plan ravintio-implement ravintio-validate-and-accept ravintio-ship; do
  assert_contains "$CMD" "$(cat "$SKILLS/$s/SKILL.md")" "req-002 AC-1: $s holds the clock command"
  assert_contains "never type" "$(grep -F "$CMD" "$SKILLS/$s/SKILL.md" | head -1)" \
    "req-002 AC-1: $s says never to type a time"
done
assert_contains "$CMD" "$(cat "$SKILLS/ravintio-orchestrator/references/orchestrator-phase-invocation.md")" \
  "req-002 AC-1: the phase invocation reference names the clock command"

echo ""
echo "=== req-004 AC-3: the validate skill points at the failed suite list ==="
assert_contains "Failed suites:" "$(cat "$SKILLS/ravintio-validate-and-accept/SKILL.md")" \
  "req-004 AC-3: the validate skill names the Failed suites: list"

print_summary
