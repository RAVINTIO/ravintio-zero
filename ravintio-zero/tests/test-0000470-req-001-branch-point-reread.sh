#!/usr/bin/env bash
# Tests for feature 0000470-plan-rereads-files-at-the-branch-point, req-001: the plan
# skill rereads each file a unit edits at the branch point, and the execution plan
# template holds a table for the reads.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
TEMPLATE="$ZERO_DIR/templates/execution-plan.template.md"

echo ""
echo "=== req-001 AC-1: the plan skill carries the reread step ==="
SECTION=$(awk '/^## Branch-point reread/{f=1;next} /^## /{f=0} f' "$PLAN")
assert_contains "git fetch origin" "$SECTION" "req-001 AC-1: the section fetches origin"
assert_contains "origin/{base}" "$SECTION" "req-001 AC-1: the section reads the base tip"
assert_contains "git log -1" "$SECTION" "req-001 AC-1: the section notes the last commit"
assert_rule "plan-branch-point-reread" "git fetch origin" "origin/{base}" "Branch-point reads"

echo ""
echo "=== req-001 AC-2: the template carries the table ==="
TABLE=$(awk '/^## Branch-point reads/{f=1;next} /^## /{f=0} f' "$TEMPLATE")
assert_contains "| File | Commit read | Unit |" "$TABLE" "req-001 AC-2: the section holds the three columns"
READS_LINE=$(grep -n '^## Branch-point reads' "$TEMPLATE" | head -1 | cut -d: -f1)
CONC_LINE=$(grep -n '^## Concurrency plan' "$TEMPLATE" | head -1 | cut -d: -f1)
ORDER=$([ -n "${READS_LINE:-}" ] && [ -n "${CONC_LINE:-}" ] && [ "$READS_LINE" -lt "$CONC_LINE" ] && echo before || echo other)
assert_equals "before" "$ORDER" "req-001 AC-2: the section sits before the Concurrency plan"

echo ""
echo "=== req-001 AC-3: a moved target repeats the reread ==="
assert_contains "moves" "$SECTION" "req-001 AC-3: the section covers a moved base"
assert_contains "plan gate" "$SECTION" "req-001 AC-3: the repeat comes before the plan gate"

echo ""
echo "=== req-001 AC-4: the section stays small ==="
LINES=$(printf '%s\n' "$SECTION" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -gt 0 ] && [ "$LINES" -le 20 ] && echo yes || echo no)" "req-001 AC-4: the section holds 1 to 20 lines ($LINES)"

print_summary
