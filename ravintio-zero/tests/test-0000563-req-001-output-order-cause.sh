#!/usr/bin/env bash
# Tests for feature 0000563-test-impact-misses-output-readers, req-001:
# the scan names an Output order cause for suites that read changed lines or the last line.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"

echo ""
echo "=== REQ-001 AC-1 and AC-2: the cause names both readers ==="
assert_rule piv-cause-output-order "**Output order:**" "last line" "line text" "tests"

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
