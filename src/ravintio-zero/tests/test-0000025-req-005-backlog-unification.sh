#!/usr/bin/env bash
# Tests for feature 0000025, req-005: backlog unification for deferred items.
#
# Confirms:
#   1. ravintio-zero/templates/backlog-entry.template.md carries the
#      "Deferral source" field distinguishing discovered mid-flight,
#      deliberate scope decision, and tech debt.
#   2. Backlog mechanics (monotonic id sequence, pull-in/leave/discard
#      pickup) live in the orchestrator's discovery text.
#   3. Subagent out-of-scope filing routes through
#      standards/agent-dispatch-standards.md with a pre-assigned id.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TEMPLATE="$ZERO_DIR/templates/backlog-entry.template.md"
ORCHESTRATOR="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
DISPATCH="$ZERO_DIR/standards/agent-dispatch-standards.md"

grep_has() { grep -q "$1" "$2" 2>/dev/null && echo "yes" || echo "no"; }

echo ""
echo "=== req-005: backlog-entry.template.md has a Deferral source field ==="

assert_equals "yes" "$(grep_has '\*\*Deferral source:\*\*' "$TEMPLATE")" \
  "req-005: template has a Deferral source field"
assert_equals "yes" "$(grep_has 'discovered mid-flight' "$TEMPLATE")" \
  "req-005: template's Deferral source field names discovered mid-flight"
assert_equals "yes" "$(grep_has 'deliberate scope decision' "$TEMPLATE")" \
  "req-005: template's Deferral source field names deliberate scope decision"
assert_equals "yes" "$(grep_has 'tech debt' "$TEMPLATE")" \
  "req-005: template's Deferral source field names tech debt"

echo ""
echo "=== req-005: template retains source and id-allocation fields ==="

assert_equals "yes" "$(grep_has '\*\*Source feature:\*\*' "$TEMPLATE")" \
  "req-005: template still has Source feature field"
assert_equals "yes" "$(grep_has '\*\*Source phase:\*\*' "$TEMPLATE")" \
  "req-005: template still has Source phase field"
assert_equals "yes" "$(grep_has 'counter file' "$TEMPLATE")" \
  "req-005: template documents the counter-file allocation convention"

echo ""
echo "=== req-005: backlog mechanics live in the orchestrator's discovery text ==="

assert_rule p0-start-backlog-pickup "Backlog pickup" "pull-in / leave / discard" "counter file" "spent ids never return"

echo ""
echo "=== req-005: subagent filing routes through the dispatch standards ==="

assert_rule orc-dispatch-backlog-filing 'plan/backlog/{id}-{slug}/entry.md' "Deferral source: discovered mid-flight" "backlog-entry.template.md"
assert_rule orc-dispatch-backlog-id "pre-computes the next available backlog ID"

print_summary
