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
O=$(cat "$ORCH")
assert_contains "while any subagent" "$O" "req-001 AC-1: the rule names a running subagent"
assert_contains "\`git stash\`" "$O" "req-001 AC-1: git stash"
assert_contains "\`git checkout -- {path}\`" "$O" "req-001 AC-1: git checkout -- {path}"
assert_contains "\`git reset\`" "$O" "req-001 AC-1: git reset"
assert_contains "\`git clean\`" "$O" "req-001 AC-1: git clean"

echo ""
echo "=== req-001 AC-2: the implement skill names the clone and the log note ==="
I=$(cat "$IMPL")
assert_contains "while any subagent" "$I" "req-001 AC-2: the rule names a running subagent"
assert_contains "\`git stash\`" "$I" "req-001 AC-2: git stash"
assert_contains "\`git checkout -- {path}\`" "$I" "req-001 AC-2: git checkout -- {path}"
assert_contains "\`git reset\`" "$I" "req-001 AC-2: git reset"
assert_contains "\`git clean\`" "$I" "req-001 AC-2: git clean"
assert_contains "scratch clone" "$I" "req-001 AC-2: the scratch clone"
assert_contains "waits for its subagents" "$I" "req-001 AC-2: the build log note"

echo ""
echo "=== req-001 AC-3: the caps hold ==="
BYTES=$(wc -c < "$ORCH" | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator holds $BYTES bytes (cap 9000)"
TOTAL=$(cat "$ZERO_DIR"/skills/*/SKILL.md | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-001 AC-3: skill text $TOTAL lines (cap 1720)"

print_summary
