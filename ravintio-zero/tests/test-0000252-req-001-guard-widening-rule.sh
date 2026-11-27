#!/usr/bin/env bash
# Tests for feature 0000252-chart-rules, req-001: chart checks each backlog entry for a
# guard widening and needs a separate human approval for each one.
#
# AC-1: the standard holds the guard check.
# AC-2: the initiative skill holds the same rule.
# AC-3 (the hooks stay unchanged) is a branch property that P3 checks with git diff.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
STANDARDS="$ZERO_DIR/standards/roadmap-standards.md"

echo ""
echo "=== req-001 AC-1: the standard holds the guard check ==="
assert_rule rm-chart-guard-check "guard check" "\`merge-guard\`" "\`gate-write\`" "\`ratchet-check\`" "any other fail-closed hook"
assert_rule rm-chart-guard-bullets "separate approval" "new forms"

echo ""
echo "=== req-001 AC-2: the initiative skill holds the same rule ==="
assert_rule rm-ini-guard "guard check" "separate approval" "fail-closed hook"

echo ""
echo "=== req-001 AC-3: the hooks stay unchanged ==="
echo "  (checked in P3 with git diff against the initiative branch)"

print_summary
