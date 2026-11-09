#!/usr/bin/env bash
# Tests for feature 0000383-test-impact-scan, req-001 to req-005: the plan skill's
# Test impact scan names each new cause, and the implement and test skills follow.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")

echo ""
echo "=== req-001 AC-1: reference file edits ==="
assert_contains "references/" "$SCAN" "req-001 AC-1: the scan names the references folder"
assert_contains "frozen-line" "$SCAN" "req-001 AC-1: the scan names the frozen-line tests"

echo ""
echo "=== req-002 AC-1: a new test file ==="
assert_contains "test-0000164-req-008" "$SCAN" "req-002 AC-1: the scan names the style test"

echo ""
echo "=== req-003 AC-1: the runner allowlist ==="
assert_contains "run-tests.sh" "$SCAN" "req-003 AC-1: the scan names run-tests.sh"
assert_contains "run-tests.ps1" "$SCAN" "req-003 AC-1: the scan names run-tests.ps1"

echo ""
echo "=== req-004: fixture pins ==="
assert_contains "tests/fixtures/" "$SCAN" "req-004 AC-1: the scan names the fixtures folder"
IMPL=$(cat "$ZERO_DIR/skills/ravintio-implement/SKILL.md")
assert_contains "before the full suite" "$IMPL" "req-004 AC-2: P2 runs the named suites before the full suite"

echo ""
echo "=== req-005: the repo's own tests ==="
assert_contains "__tests__/" "$SCAN" "req-005 AC-1: the scan names the common folder names"
assert_contains "stack" "$SCAN" "req-005 AC-1: the scan reads the stack declaration"
assert_contains "ravintio-zero/tests/" "$SCAN" "req-005 AC-2: the scan still names the pack tests"
for S in ravintio-test-writer ravintio-refactor ravintio-validate-and-accept; do
  assert_contains "repo's own test" "$(cat "$ZERO_DIR/skills/$S/SKILL.md")" "req-005 AC-3: $S names the repo's own tests"
done

echo ""
echo "=== NFR: scan size and skill text ==="
LINES=$(printf '%s\n' "$SCAN" | grep -c . || true)
assert_equals "yes" "$([ "$LINES" -le 20 ] && echo yes || echo no)" "NFR-001: the scan holds $LINES lines (cap 20)"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "NFR-002: skill text $TOTAL <= 1720"

print_summary
