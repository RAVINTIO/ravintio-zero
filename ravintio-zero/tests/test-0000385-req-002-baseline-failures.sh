#!/usr/bin/env bash
# Test: 0000385 req-002 baseline-failures
# baseline-failures.mjs records the failed suites on the base commit. P3 stops only
# on a failed suite that the baseline does not list.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$ZERO_DIR/scripts/baseline-failures.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

out_with() { # out_with <file> <suite>...
  local f="$1"; shift
  { echo "Feature suites:    5 passed, $# failed."; echo "Failed suites:"; for s in "$@"; do echo "  $s"; done; } > "$f"
}
out_with "$WORK/base.txt" test-a.sh
mkdir -p "$WORK/plan/current"
BASE="$WORK/plan/current/baseline-failures.md"

echo "=== AC-1: matching failures pass and are listed ==="
node "$SCRIPT" record "$WORK/base.txt" --file "$BASE" >/dev/null; RC=$?
assert_equals "0" "$RC" "record exits 0"
assert_contains "test-a.sh" "$(cat "$BASE")" "the baseline file lists the failed suite"
OUT="$(node "$SCRIPT" check "$WORK/base.txt" --file "$BASE")"; RC=$?
assert_equals "0" "$RC" "check exits 0 when only the baseline suite fails"
assert_contains "inherited: test-a.sh" "$OUT" "check lists the inherited suite"

echo "=== AC-2: a new failure stops ==="
out_with "$WORK/now.txt" test-a.sh test-b.sh
OUT="$(node "$SCRIPT" check "$WORK/now.txt" --file "$BASE")"; RC=$?
assert_equals "1" "$RC" "check exits 1 when a suite is new"
assert_contains "new: test-b.sh" "$OUT" "check names the new suite"
assert_contains "inherited: test-a.sh" "$OUT" "check still lists the inherited suite"

echo "=== AC-3: no baseline file means an empty baseline ==="
OUT="$(node "$SCRIPT" check "$WORK/now.txt" --file "$WORK/none.md")"; RC=$?
assert_equals "1" "$RC" "check exits 1 with no baseline file"
assert_contains "new: test-a.sh" "$OUT" "every failure is new"

echo "=== a green run records an empty baseline ==="
printf 'Feature suites:    9 passed, 0 failed.\n' > "$WORK/green.txt"
node "$SCRIPT" record "$WORK/green.txt" --file "$BASE" >/dev/null
OUT="$(node "$SCRIPT" check "$WORK/green.txt" --file "$BASE")"; RC=$?
assert_equals "0" "$RC" "a green run passes against an empty baseline"
assert_equals "" "$OUT" "a green run prints nothing"
node "$SCRIPT" check "$WORK/missing.txt" --file "$BASE" >/dev/null 2>&1; RC=$?
assert_equals "2" "$RC" "an unreadable runner output exits 2"

echo "=== skill text ==="
assert_rule p0-start-baseline "baseline-failures.mjs" "baseline-failures.md" "base commit"
assert_rule p3-baseline-check "baseline-failures.mjs check" "inherited"
assert_rule ship-inherited-failures "inherited" "backlog entry"

print_summary
