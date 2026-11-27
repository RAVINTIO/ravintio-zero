#!/usr/bin/env bash
# Tests for feature 0000359-safe-parallel-commits, req-001: the orchestrator and
# implement skills ban tree-wide git commands while a subagent runs and name the
# scratch clone as the way to test a clean tree.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"

echo ""
echo "=== req-001 AC-1: the orchestrator names the commands ==="
assert_rule orc-orch-no-tree-git "while any subagent" "\`git stash\`" "\`git checkout -- {path}\`" "\`git reset\`" "\`git clean\`"

echo ""
echo "=== req-001 AC-2: the implement skill names the clone and the log note ==="
assert_rule orc-impl-no-tree-git "while any subagent" "\`git stash\`" "\`git checkout -- {path}\`" "\`git reset\`" "\`git clean\`" "scratch clone" "waits for its subagents"

echo ""
echo "=== req-001 AC-3: the caps hold ==="
BYTES=$(strip_rule_anchors < "$ORCH" | wc -c | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator holds $BYTES bytes (cap 9000)"
TOTAL=$(cat "$ZERO_DIR"/skills/*/SKILL.md | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-001 AC-3: skill text $TOTAL lines (cap 1720)"

print_summary
