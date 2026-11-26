#!/usr/bin/env bash
# Tests for feature 0000247-git-state-hygiene, req-001: the orchestrator and
# ship skills tell a step of an active initiative to stage by explicit path and
# never to stage a backlog entry the step did not write.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

echo ""
echo "=== req-001 AC-1: the orchestrator carries the rule ==="
assert_rule rm-orch-driver-files "active initiative" "explicit path" "plan/backlog/" "did not write"

echo ""
echo "=== req-001 AC-2: the ship skill carries the rule ==="
assert_rule orc-ship-stage-by-path "active initiative" "explicit path" "plan/changelog/" "plan/_archive/" "did not write"

echo ""
echo "=== req-001 AC-3: the orchestrator stays under its cap ==="
BYTES=$(strip_rule_anchors < "$ORCH" | wc -c | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator SKILL.md holds $BYTES bytes (cap 9000)"

print_summary
