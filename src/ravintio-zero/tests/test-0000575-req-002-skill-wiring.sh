#!/usr/bin/env bash
# Test: 0000575 req-002 skill-wiring
# The implement skill and two standards name build-log-mark.mjs for the marker lines.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== AC-1: the implement skill names the script ==="
assert_rule implement-inline-unit "build-log-mark.mjs" "RED:" "GREEN:" "Done:"

echo "=== AC-2: the standards name the script ==="
GOV="$(cat "$ZERO_DIR/standards/workflow-governance-standards.md")"
DISPATCH="$(cat "$ZERO_DIR/standards/agent-dispatch-standards.md")"
assert_contains "build-log-mark.mjs" "$GOV" "AC-2: the governance standard names the script"
assert_contains "build-log-mark.mjs" "$DISPATCH" "AC-2: the dispatch standard names the script"

print_summary
