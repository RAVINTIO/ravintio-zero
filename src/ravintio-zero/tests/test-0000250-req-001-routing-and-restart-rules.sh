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
ROUTE=$(awk '/^## Repo instructions during a run/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "plan/current-initiative/initiative.md" "$ROUTE" "req-001 AC-1: the rule names initiative.md as the target"
assert_contains "current or next pending step" "$ROUTE" "req-001 AC-1: the rule names the current or next pending step as the scope"
assert_contains "never writes" "$ROUTE" "req-001 AC-1: the rule says the skill never writes the override"
assert_contains "driver holds the lock" "$ROUTE" "req-001 AC-1: the rule covers the held lock"

echo ""
echo "=== req-001 AC-2: the skill holds the restart rule ==="
STOPS=$(awk '/^## Stops/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "Restart:" "$STOPS" "req-001 AC-2: the Stops section names the Restart: line"
assert_contains "without asking" "$STOPS" "req-001 AC-2: the skill restarts without asking"
assert_contains "new driver" "$STOPS" "req-001 AC-2: the skill starts a new driver"
assert_contains "watcher" "$STOPS" "req-001 AC-2: the skill starts a new watcher"

echo ""
echo "=== req-001: roadmap standards hold the same rules ==="
assert_contains "current or next pending step" "$(cat "$STANDARDS")" "req-001: standards hold the routing rule"
assert_contains "I-D Advance: Restart:" "$(cat "$STANDARDS")" "req-001: standards hold the restart stop"

print_summary
