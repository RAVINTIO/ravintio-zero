#!/usr/bin/env bash
# Tests for feature 0000583-step-temp-cleanup-after-merge, REQ-004: the standards and the implement
# skill tell the agent to put scratch under $TMPDIR.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo ""
echo "=== REQ-004 AC-1: the testing standards hold the rule ==="
assert_rule scratch-under-tmpdir '$TMPDIR' '/tmp' 'EXIT'

echo ""
echo "=== REQ-004 AC-2: the implement skill points to the rule ==="
SKILL="$SCRIPT_DIR/../skills/ravintio-implement/SKILL.md"
assert_contains "scratch-under-tmpdir" "$(cat "$SKILL")" "REQ-004 AC-2: the implement skill names the rule"

print_summary
