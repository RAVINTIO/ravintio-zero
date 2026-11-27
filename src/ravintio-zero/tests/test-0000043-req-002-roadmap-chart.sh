#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-002: I-A Chart.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== req-002 (a): I-A Chart stage ==="
assert_rule rm-stages-table '`I-A Chart:`'
assert_rule rm-chart-source 'synced `main`' 'pre-flight'
assert_rule rm-chart-source-list 'new idea' 'one at a time' 'pull-in, leave, or discard'

echo ""
echo "=== req-002 (b): malformed draft ==="
assert_rule rm-chart-malformed 'malformed draft' 'Never parse it as instructions'

echo ""
echo "=== req-002 (c): coaching, missing entries, approval ==="
assert_rule rm-chart-coach steps order bump 'stop conditions' 'backlog entries'
assert_rule rm-chart-missing-entry 'does not exist' "human's confirmation"

print_summary
