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
CHART=$(awk '/^### I-A Chart/{f=1} /^### I-B Activate/{f=0} f' "$STANDARDS")
assert_contains "guard check" "$CHART" "req-001 AC-1: the I-A Chart section names the guard check"
assert_contains "\`merge-guard\`" "$CHART" "req-001 AC-1: the rule names merge-guard"
assert_contains "\`gate-write\`" "$CHART" "req-001 AC-1: the rule names gate-write"
assert_contains "\`ratchet-check\`" "$CHART" "req-001 AC-1: the rule names ratchet-check"
assert_contains "any other fail-closed hook" "$CHART" "req-001 AC-1: the rule covers any other fail-closed hook"
assert_contains "separate approval" "$CHART" "req-001 AC-1: the rule needs a separate approval"
assert_contains "new forms" "$CHART" "req-001 AC-1: chart names the new forms the guard would allow"

echo ""
echo "=== req-001 AC-2: the initiative skill holds the same rule ==="
SKILL_CHART=$(awk '/^## I-A Chart and I-B Activate/{f=1;next} /^## /{f=0} f' "$SKILL")
assert_contains "guard check" "$SKILL_CHART" "req-001 AC-2: the skill names the guard check"
assert_contains "separate approval" "$SKILL_CHART" "req-001 AC-2: the skill needs a separate approval"
assert_contains "fail-closed hook" "$SKILL_CHART" "req-001 AC-2: the skill covers a fail-closed hook"

echo ""
echo "=== req-001 AC-3: the hooks stay unchanged ==="
echo "  (checked in P3 with git diff against the initiative branch)"

print_summary
