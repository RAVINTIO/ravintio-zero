#!/usr/bin/env bash
# Tests for feature 0000559-start-baseline-first, req-001:
# the baseline run starts before any P0 artifact, and the start action
# numbers cited elsewhere match the order.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
P0="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md"
SKILL="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
ROAD="$ZERO_DIR/standards/roadmap-standards.md"

# The position of an action: the number in front of its rule anchor.
pos() { grep -E "^[0-9]+\. <!-- rule: $1 -->" "$P0" | sed -E 's/^([0-9]+)\..*/\1/'; }
before() { [ -n "$1" ] && [ -n "$2" ] && [ "$1" -lt "$2" ] && echo yes || echo no; }

BASE=$(pos p0-start-baseline)
DEC=$(pos p0-start-decisions)
PRE=$(pos p0-start-preflight)

echo ""
echo "=== REQ-001 AC-1: the baseline comes before every artifact action ==="
for r in p0-start-stale-run-mode p0-start-sentinel p0-start-build-log p0-start-discovery-md; do
  assert_equals "yes" "$(before "$BASE" "$(pos $r)")" "REQ-001 AC-1: baseline ($BASE) before $r"
done

echo ""
echo "=== REQ-001 AC-2: the decision rows follow the pre-flight and precede the baseline ==="
assert_equals "yes" "$(before "$PRE" "$DEC")" "REQ-001 AC-2: pre-flight ($PRE) before decisions ($DEC)"
assert_equals "yes" "$(before "$DEC" "$BASE")" "REQ-001 AC-2: decisions ($DEC) before baseline ($BASE)"

echo ""
echo "=== REQ-001 AC-3: cited step numbers match the order ==="
assert_contains "before the baseline run in step $BASE" "$(cat "$P0")" "REQ-001 AC-3: the decisions action names the baseline step"
assert_contains "Discovery Start Actions step $(pos p0-start-skills-inbox) cites" "$(cat "$P0")" "REQ-001 AC-3: the catalogue sentence names the skills inbox step"
assert_contains "Step $(pos p0-start-adoption-mode) uses the Adoption Modes" "$(cat "$SKILL")" "REQ-001 AC-3: the skill names the adoption mode step"
assert_contains "Discovery Start Actions step $(pos p0-start-version)." "$(grep 'rule: icrun-bump' "$ROAD")" "REQ-001 AC-3: the bump rule names the version step"
assert_contains "Discovery Start Actions step $PRE." "$(cat "$ROAD")" "REQ-001 AC-3: the chart text names the pre-flight step"

print_summary
