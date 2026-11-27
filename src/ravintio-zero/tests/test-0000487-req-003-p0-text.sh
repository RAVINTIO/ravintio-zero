#!/usr/bin/env bash
# Test: 0000487 req-003 P0 applies and logs the Decisions rows
# The P0 start actions and the roadmap standards describe the lookup, the log lines, and the check.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
echo ""
echo "=== req-003 AC-1: the start action exists ==="
assert_rule p0-start-decisions "decision-rows.mjs list --step" "Decision applied (initiative chart): {fork}" "Decision not applicable (initiative chart): {fork}: {reason}" "Decisions: none name step {n}"

echo ""
echo "=== req-003 AC-2: the standards describe the check ==="
assert_rule icrun-decision-row "decision-rows.mjs" "build-log-check.mjs"

print_summary
