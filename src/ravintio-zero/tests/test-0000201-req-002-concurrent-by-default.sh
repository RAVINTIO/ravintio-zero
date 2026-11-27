#!/usr/bin/env bash
# Tests for feature 0000201-plan-concurrent-work, req-002: the dispatch standard
# states the concurrent default and the departure rule, and the implement skill
# dispatches by the batches of the plan's concurrency plan.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/agent-dispatch-standards.md"
IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"

echo ""
echo "=== req-002 AC-1: the standard states the default ==="
assert_contains "## Concurrency plan" "$(cat "$STD")" "req-002 AC-1: the standard has a Concurrency plan section"
assert_rule piv-dispatch-concurrency-batch "no dependency and no shared write target" "share a batch"
assert_rule piv-dispatch-concurrency-sequential "Sequential reason"

echo ""
echo "=== req-002 AC-2: the standard covers departures ==="
assert_rule piv-dispatch-concurrency-departure "departure" "build log" "with its reason"

echo ""
echo "=== req-002 AC-3: implement dispatches by batch ==="
assert_rule piv-implement-parallel-batches "Concurrency plan" "plan/current/execution-plan.md" "batches"

print_summary
