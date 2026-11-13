#!/usr/bin/env bash
# Test: 0000385 req-001 affected-tests
# P2 runs the tests a unit can affect in each cycle and the full suite once. P3 still
# requires a full green suite before acceptance.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== AC-1: the implement skill names the rules ==="
assert_rule implement-affected-tests "new test" "cover" "changed files"
assert_rule implement-full-suite-once "one full suite run" "before P2 completes" "background"
assert_rule refactor-affected-tests "tests" "changed files"
assert_not_contains "Run the full suite" "$(rule_text refactor-affected-tests)" "refactor leaves the full run to implement"

echo "=== AC-2: the build log records each cycle ==="
assert_rule implement-tests-run-line "Tests run:" "build log"
assert_contains "Tests run:" "$(cat "$ZERO_DIR/templates/build-log.template.md")" "the build-log template shows the Tests run line"

echo "=== AC-3: P3 still needs a full green suite ==="
assert_rule p3-full-suite "full suite" "once" "before acceptance"
assert_rule p3-rerun-failed "failed" "rerun"

print_summary
