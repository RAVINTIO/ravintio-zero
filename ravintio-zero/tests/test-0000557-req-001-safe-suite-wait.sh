#!/usr/bin/env bash
# Tests for feature 0000557-self-matching-pgrep-wait, req-001:
# the P0 start actions and the validate skill name the safe wait,
# and no skill or standard tells a session to wait with pgrep -f.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
P0="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md"
VA="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"

echo ""
echo "=== AC-1: P0 baseline start action names the wait ==="
assert_rule p0-start-baseline "end marker" "process id" "pgrep -f"

echo ""
echo "=== AC-2: the validate fast batch names the wait ==="
assert_rule orc-p3-fast-suite-wait "end marker" "process id" "pgrep -f"

echo ""
echo "=== AC-3: no skill or standard waits with pgrep -f ==="
BAD="$(grep -rn 'pgrep -f' "$ZERO_DIR/skills" "$ZERO_DIR/standards" 2>/dev/null | grep -v 'Never' || true)"
assert_equals "" "$BAD" "AC-3: every pgrep -f line in skills and standards holds Never"

print_summary
