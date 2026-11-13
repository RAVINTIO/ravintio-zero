#!/usr/bin/env bash
# Test: 0000380 req-003 timeout-helper
# with_timeout caps a command on macOS, Linux, and Git Bash. It stops a command
# that outlives its limit with exit 124 and passes the exit code of one that does not.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/timeout.sh"

run_cases() {
  local label="$1" start rc elapsed
  echo "=== $label ==="
  start=$(date +%s)
  with_timeout 1 sleep 30; rc=$?
  elapsed=$(( $(date +%s) - start ))
  assert_equals "124" "$rc" "$label: a command that outlives its limit exits 124"
  assert_equals "yes" "$([ "$elapsed" -le 5 ] && echo yes || echo no)" "$label: the helper returns within 5 seconds ($elapsed)"

  with_timeout 5 bash -c 'exit 3'; rc=$?
  assert_equals "3" "$rc" "$label: a command that finishes in time keeps its exit code"

  with_timeout 5 true; rc=$?
  assert_equals "0" "$rc" "$label: a passing command exits 0"

  assert_equals "hello" "$(with_timeout 5 echo hello)" "$label: output passes through"
}

run_cases "perl path (or the only path when perl is absent)"
RAVINTIO_TIMEOUT_NO_PERL=1 run_cases "bash watchdog path"

echo "=== portability ==="
assert_equals "0" "$(grep -v '^[[:space:]]*#' "$SCRIPT_DIR/helpers/timeout.sh" | grep -cE '(^|[^_a-z])(timeout|gtimeout) ')" "the helper never calls timeout or gtimeout"

echo "=== adoption ==="
assert_equals "0" "$(grep -c 'alarm' "$SCRIPT_DIR/test-0000321-req-005-default-migration.sh")" "the 0000321 suite holds no inline perl alarm"
assert_contains "with_timeout" "$(cat "$SCRIPT_DIR/test-0000321-req-005-default-migration.sh")" "the 0000321 suite uses with_timeout"
assert_contains "with_timeout" "$(cat "$ZERO_DIR/standards/testing-standards.md")" "testing-standards.md names the helper"
assert_contains "helpers/timeout.sh" "$(cat "$SCRIPT_DIR/run-tests.sh")" "run-tests.sh lists the helper as a known non-suite"

print_summary
