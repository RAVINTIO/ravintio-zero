#!/usr/bin/env bash
# Test: 0000487 req-003 P0 applies and logs the Decisions rows
# The P0 start actions and the roadmap standards describe the lookup, the log lines, and the check.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
START=$(cat "$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md")
RULE=$(grep 'rule: icrun-decision-row' "$ZERO_DIR/standards/roadmap-standards.md")

echo ""
echo "=== req-003 AC-1: the start action exists ==="
assert_contains "rule: p0-start-decisions" "$START" "req-003 AC-1: the anchor"
assert_contains "decision-rows.mjs list --step" "$START" "req-003 AC-1: the command"
assert_contains "Decision applied (initiative chart): {fork}" "$START" "req-003 AC-1: the applied line"
assert_contains "Decision not applicable (initiative chart): {fork}: {reason}" "$START" "req-003 AC-1: the skipped line"
assert_contains "Decisions: none name step {n}" "$START" "req-003 AC-1: the empty line"

echo ""
echo "=== req-003 AC-2: the standards describe the check ==="
assert_contains "decision-rows.mjs" "$RULE" "req-003 AC-2: the rule names the module"
assert_contains "build-log-check.mjs" "$RULE" "req-003 AC-2: the rule names the check"

print_summary
