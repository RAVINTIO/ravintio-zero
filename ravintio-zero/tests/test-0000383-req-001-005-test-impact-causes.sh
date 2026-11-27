#!/usr/bin/env bash
# Tests for feature 0000383-test-impact-scan, req-001 to req-005: the plan skill's
# Test impact scan names each new cause, and the implement and test skills follow.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN"; cat "$(dirname "$PLAN")/references/test-impact-causes.md")

echo ""
echo "=== req-001 AC-1: reference file edits ==="
assert_rule piv-cause-reference-edit "references/" "frozen-line"

echo ""
echo "=== req-002 AC-1: a new test file ==="
assert_rule piv-cause-new-test-file "test-0000164-req-008"

echo ""
echo "=== req-003 AC-1: the runner allowlist ==="
assert_rule piv-cause-new-test-file "run-tests.sh" "run-tests.ps1"

echo ""
echo "=== req-004: fixture pins ==="
assert_rule piv-cause-fixture-pinned "tests/fixtures/"
assert_rule piv-implement-impact-suites-first "before the full suite"

echo ""
echo "=== req-005: the repo's own tests ==="
assert_rule piv-plan-impact-scan "__tests__/" "stack" "ravintio-zero/tests/"
assert_rule piv-testwriter-test-dir "repo's own test"
assert_rule refactor-affected-tests "repo's own test"
assert_rule piv-p3-test-step "repo's own test"

echo ""
echo "=== NFR: scan size and skill text ==="
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 21 ] && echo yes || echo no)" "NFR-001: the scan holds $LINES lines (cap 21)"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "NFR-002: skill text $TOTAL <= 1720"

print_summary
