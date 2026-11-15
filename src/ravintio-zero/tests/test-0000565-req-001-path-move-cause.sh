#!/usr/bin/env bash
# Tests for feature 0000565-layout-move-test-impact, req-001:
# the scan names a Path move cause with two greps and the path-keyed state files.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
CAUSE=$(grep -F '**Path move:**' "$REF" 2>/dev/null || true)

echo ""
echo "=== REQ-001 AC-1: the reference file names the cause ==="
assert_contains "**Path move:**" "$(cat "$REF" 2>/dev/null || true)" "REQ-001 AC-1: the file names the Path move cause"

echo ""
echo "=== REQ-001 AC-2: the cause names the greps and the state files ==="
assert_contains '$ZERO_DIR/..' "$CAUSE" "REQ-001 AC-2: the cause names the ZERO_DIR lookup"
assert_contains 'SCRIPT_DIR/../..' "$CAUSE" "REQ-001 AC-2: the cause names the SCRIPT_DIR lookup"
assert_contains "plan/state/prose-baseline.json" "$CAUSE" "REQ-001 AC-2: the cause names the prose baseline"
assert_contains "renames or moves a folder" "$CAUSE" "REQ-001 AC-2: the cause names its trigger"

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
