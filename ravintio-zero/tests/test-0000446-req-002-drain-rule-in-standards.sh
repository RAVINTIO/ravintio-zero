#!/usr/bin/env bash
# Tests for feature 0000446, REQ-002: the roadmap standards state that the queue keeps merging
# other ready PRs after a queue failure.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$SCRIPT_DIR/../standards/roadmap-standards.md"
RUN="$SCRIPT_DIR/../scripts/initiative-run.mjs"

echo ""
echo "=== REQ-002 AC-1: the drain rule is in the roadmap standards ==="
assert_rule rm-driver-drain "the queue still merges every other ready step, also after a queue failure" "A failed step gets one attempt in a driver run, keeps its \`ready\` file, and reads \`stopped\` in the report." "A new driver queues it again."

echo ""
echo "=== REQ-002: the old hold is gone ==="
assert_not_contains "unless the queue failed" "$(cat "$STD" "$RUN")" "REQ-002: no text holds the queue after a failure"

print_summary
