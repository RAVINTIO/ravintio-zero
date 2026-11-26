#!/usr/bin/env bash
# Tests for feature 0000202-improvement-loops, req-001: the implement skill runs
# a capped improvement loop after GREEN, and the refactor skill has an
# improvement mode.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"
REFACTOR="$ZERO_DIR/skills/ravintio-refactor/SKILL.md"
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"

echo ""
echo "=== req-001 AC-1: the implement skill runs a capped loop after GREEN ==="
assert_contains "## Improvement loop" "$(cat "$IMPL")" "req-001 AC-1: the implement skill has an Improvement loop section"
assert_rule piv-implement-improvement-loop "agent-dispatch-standards.md" "2 cycles" "per requirement"
assert_contains "## Improvement loop" "$(cat "$STD")" "req-001 AC-1: the dispatch standard has an Improvement loop section"
assert_rule piv-implement-tdd-loop-block "improvement loop"
assert_rule piv-implement-fast-track "improvement loop"

echo ""
echo "=== req-001 AC-2: the reviewer is fresh and the loop stops early ==="
assert_rule piv-dispatch-improve-reviewer "fresh context"
assert_rule piv-dispatch-improve-finding "no change worth making"
assert_rule piv-dispatch-improve-early-stop "stops early"
assert_rule piv-dispatch-improve-revert "reverts"
assert_rule piv-implement-improvement-loop "Improve:"
assert_rule piv-dispatch-improve-resume "count the"

echo ""
echo "=== req-001 AC-3: the refactor skill has an improvement mode ==="
assert_rule piv-refactor-improvement-mode "In improvement mode" "with the Hard Limits in force" "Apply only the change" "reverts the change"

print_summary
