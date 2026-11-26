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
assert_rule piv-cause-skill-count "Skill count"
assert_rule piv-cause-skill-text-budget "Skill-text budget"
assert_rule piv-cause-size-cap "Size cap"
assert_rule piv-cause-backlog-id "Backlog entry id"
assert_rule piv-cause-workflow-job "Workflow job or step edit"
assert_rule piv-cause-reference-edit "Reference file edit"
assert_rule piv-cause-new-test-file "New test file" "Non-suite file"
assert_rule piv-cause-fixture-pinned "Fixture-pinned line"

echo ""
echo "=== REQ-001 AC-2: the scan section and the Pack Index name the file ==="
assert_contains "references/test-impact-causes.md" "$SCAN" "REQ-001 AC-2: the scan section names the file"
assert_contains "references/test-impact-causes.md" "$INDEX" "REQ-001 AC-2: the Pack Index names the file"
assert_not_contains "**Skill count:**" "$SCAN" "REQ-001 AC-2: the causes left the scan section"

echo ""
echo "=== REQ-002 AC-1: the Pack file edit cause names the handoff suite ==="
assert_rule orc-cause-pack-file-edit "**Pack file edit:**" "test-0000493-req-004-handoff-text.sh"

echo ""
echo "=== REQ-002 AC-2: the cause names both trees ==="
assert_rule orc-cause-pack-file-edit "src/ravintio-zero/" "ravintio-zero/"

echo ""
echo "=== REQ-003 AC-1: P0 lists the source tree in Component Paths ==="
assert_rule p0-gate-pack-paths "Component Paths" "src/ravintio-zero/"

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
