#!/usr/bin/env bash
# Tests for feature 0000564-test-impact-hook-pins, req-001:
# the scan names a Hook change cause with four grep targets.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
CAUSE=$(grep -F '**Hook change:**' "$REF" 2>/dev/null || true)

echo ""
echo "=== REQ-001 AC-1: the reference file names the cause ==="
assert_contains "**Hook change:**" "$(cat "$REF" 2>/dev/null || true)" "REQ-001 AC-1: the file names the Hook change cause"

echo ""
echo "=== REQ-001 AC-2: the cause names the four grep targets ==="
assert_contains "hook name" "$CAUSE" "REQ-001 AC-2: the cause names the hook name"
assert_contains "count words" "$CAUSE" "REQ-001 AC-2: the cause names hook count words"
assert_contains "expected-after.txt" "$CAUSE" "REQ-001 AC-2: the cause names the fixture"
assert_contains "pack-facts" "$CAUSE" "REQ-001 AC-2: the cause names pack-facts"
assert_contains "margin" "$CAUSE" "REQ-001 AC-2: the cause names the margin text"

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
