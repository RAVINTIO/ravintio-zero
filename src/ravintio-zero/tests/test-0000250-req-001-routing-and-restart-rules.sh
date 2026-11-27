#!/usr/bin/env bash
# Tests for feature 0000250-initiative-mid-run-changes, req-001: the initiative skill routes
# a mid-run repo instruction into step scope and restarts the driver on the restart stop.
#
# AC-1: the skill holds the routing rule.
# AC-2: the skill holds the restart rule.
# AC-3 (the gate-write hook stays unchanged) is a branch property that P3 checks with git diff.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"

echo ""
echo "=== req-001 AC-1: the skill holds the routing rule ==="
assert_rule rm-ini-route "plan/current-initiative/initiative.md" "current or next pending step" "never writes"
assert_rule rm-ini-route-queue "driver holds the lock"

echo ""
echo "=== req-001 AC-2: the skill holds the restart rule ==="
assert_rule rm-ini-restart-stop "Restart:" "without asking" "new driver" "watcher"

echo ""
echo "=== req-001: roadmap standards hold the same rules ==="
assert_rule rm-activate-route "current or next pending step"
assert_rule rm-restart-stop-line "I-D Advance: Restart:"

print_summary
