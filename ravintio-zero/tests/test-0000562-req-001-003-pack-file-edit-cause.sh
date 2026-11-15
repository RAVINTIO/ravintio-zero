#!/usr/bin/env bash
# Tests for feature 0000562-test-impact-scan-lists-the-mirrored-pack-tree, req-001 to req-003:
# the scan causes live in a reference file, the Pack file edit cause lists the handoff suite,
# and P0 lists the source tree in Component Paths.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-plan/references/test-impact-causes.md"
GATE="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-gate.md"
SCAN=$(awk '/^## Test impact scan/{f=1;next} /^## /{f=0} f' "$PLAN")
INDEX=$(awk '/^## Pack Index/{f=1;next} /^## /{f=0} f' "$PLAN")

echo ""
echo "=== REQ-001 AC-1: the reference file holds the earlier causes ==="
TEXT=$(cat "$REF" 2>/dev/null || true)
for cause in "Skill count" "Skill-text budget" "Size cap" "Backlog entry id" "Workflow job or step edit" "Reference file edit" "New test file" "Non-suite file" "Fixture-pinned line"; do
  assert_contains "$cause" "$TEXT" "REQ-001 AC-1: the reference file names $cause"
done

echo ""
echo "=== REQ-001 AC-2: the scan section and the Pack Index name the file ==="
assert_contains "references/test-impact-causes.md" "$SCAN" "REQ-001 AC-2: the scan section names the file"
assert_contains "references/test-impact-causes.md" "$INDEX" "REQ-001 AC-2: the Pack Index names the file"
assert_not_contains "**Skill count:**" "$SCAN" "REQ-001 AC-2: the causes left the scan section"

echo ""
echo "=== REQ-002 AC-1: the Pack file edit cause names the handoff suite ==="
assert_contains "**Pack file edit:**" "$TEXT" "REQ-002 AC-1: the file names the Pack file edit cause"
assert_contains "test-0000493-req-004-handoff-text.sh" "$TEXT" "REQ-002 AC-1: the cause names the handoff suite"

echo ""
echo "=== REQ-002 AC-2: the cause names both trees ==="
CAUSE=$(grep -F '**Pack file edit:**' "$REF" 2>/dev/null || true)
assert_contains "src/ravintio-zero/" "$CAUSE" "REQ-002 AC-2: the cause names the source tree"
assert_contains "ravintio-zero/" "$CAUSE" "REQ-002 AC-2: the cause names the installed tree"

echo ""
echo "=== REQ-003 AC-1: P0 lists the source tree in Component Paths ==="
RULE=$(grep -F 'pack file' "$GATE" 2>/dev/null || true)
assert_contains "Component Paths" "$RULE" "REQ-003 AC-1: the P0 gate rule names Component Paths"
assert_contains "src/ravintio-zero/" "$RULE" "REQ-003 AC-1: the rule names the source tree"

echo ""
echo "=== NFR-002: the two trees match ==="
REPO="$(cd "$SCRIPT_DIR" && git rev-parse --show-toplevel)"
for rel in skills/ravintio-plan/SKILL.md skills/ravintio-plan/references/test-impact-causes.md skills/ravintio-orchestrator/references/orchestrator-p0-gate.md; do
  if cmp -s "$REPO/src/ravintio-zero/$rel" "$REPO/ravintio-zero/$rel"; then
    assert_equals "same" "same" "NFR-002: $rel matches in both trees"
  else
    assert_equals "same" "different" "NFR-002: $rel matches in both trees"
  fi
done

print_summary
