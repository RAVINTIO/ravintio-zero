#!/usr/bin/env bash
# Tests for feature 0000452-ci-wait-before-archive, req-001: an initiative step
# raises the PR and waits for CI before it archives and clears the sentinels.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
STD="$ZERO_DIR/standards/roadmap-standards.md"

adv="$(awk '/^### I-D Advance/ {on=1; next} on && /^### / {exit} on {print}' "$STD")"
init="$(awk '/^## Initiative steps/ {on=1; next} on && /^## / {exit} on {print}' "$SHIP")"
ln() { printf '%s\n' "$2" | grep -nF -- "$1" | head -1 | cut -d: -f1; }
before() { [ -n "$1" ] && [ -n "$2" ] && [ "$1" -lt "$2" ] && echo yes || echo no; }

echo ""
echo "=== req-001 AC-1: archive follows CI in an initiative step ==="
create="$(ln 'gh pr create' "$adv")"
wait1="$(ln 'gh pr checks {n} --watch --fail-fast' "$adv")"
arch="$(ln 'Step 4' "$adv")"
assert_equals "yes" "$(before "$create" "$wait1")" "req-001 AC-1: I-D Advance raises the PR before the CI wait"
assert_equals "yes" "$(before "$wait1" "$arch")" "req-001 AC-1: I-D Advance waits for CI before Step 4"
assert_contains 'Step 4, Step 5, and Step 8 in order' "$adv" "req-001 AC-1: I-D Advance archives before it clears the sentinels"
assert_contains 'last push before `ready`' "$adv" "req-001 AC-1: the archive is the last push before ready"
assert_contains 'before Step 4' "$init" "req-001 AC-1: ship initiative section puts the PR and CI before Step 4"

echo ""
echo "=== req-001 AC-2: a failing check is fixable while the run is open ==="
assert_contains 'plan/current/' "$adv" "req-001 AC-2: the run stays open during the CI wait"
assert_contains 'Step CI fixes' "$adv" "req-001 AC-2: the chart field governs the fix"
assert_contains 'cannot edit code' "$adv" "req-001 AC-2: a failure after the archive stops the step"

echo ""
echo "=== req-001 AC-3: a normal run keeps its order ==="
l4="$(grep -n '^### Step 4' "$SHIP" | cut -d: -f1)"
l8="$(grep -n '^### Step 8' "$SHIP" | cut -d: -f1)"
l9="$(grep -n '^### Step 9' "$SHIP" | cut -d: -f1)"
assert_equals "10" "$(grep -c '^### Step ' "$SHIP")" "req-001 AC-3: ten step headings"
assert_equals "yes" "$(before "$l4" "$l8")" "req-001 AC-3: Step 4 precedes Step 8"
assert_equals "yes" "$(before "$l8" "$l9")" "req-001 AC-3: Step 8 precedes Step 9"
assert_contains 'Outside an initiative' "$(cat "$SHIP")" "req-001 AC-3: the order change applies only in an initiative"

print_summary
