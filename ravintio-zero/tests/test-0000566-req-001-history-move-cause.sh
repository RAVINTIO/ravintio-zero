#!/usr/bin/env bash
# Tests for feature 0000566-test-impact-for-history-moves, req-001:
# the scan names a History move cause that greps the tests for plan/_archive/ and lists each match.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
CAUSE=$(grep -F '**History move:**' "$REF" 2>/dev/null || true)

echo ""
echo "=== REQ-001 AC-1: the reference file names the cause ==="
assert_contains "**History move:**" "$(cat "$REF" 2>/dev/null || true)" "REQ-001 AC-1: the file names the History move cause"

echo ""
echo "=== REQ-001 AC-2: the cause names the grep and the listing ==="
assert_contains "moves or copies archived content" "$CAUSE" "REQ-001 AC-2: the cause names its trigger"
assert_contains "plan/_archive/" "$CAUSE" "REQ-001 AC-2: the cause names the grep target"
assert_contains "ravintio-zero/tests/" "$CAUSE" "REQ-001 AC-2: the cause names the tests folder"
assert_contains "List each match" "$CAUSE" "REQ-001 AC-2: the cause says to list each match"

echo ""
echo "=== REQ-001 AC-3 and NFR-001: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
rel=skills/ravintio-plan/references/test-impact-causes.md
if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
  assert_equals "same" "same" "REQ-001 AC-3: $rel matches in both trees"
else
  assert_equals "same" "different" "REQ-001 AC-3: $rel matches in both trees"
fi

print_summary
