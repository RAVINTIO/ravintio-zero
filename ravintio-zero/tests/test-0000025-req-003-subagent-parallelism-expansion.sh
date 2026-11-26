#!/usr/bin/env bash
# Tests for feature 0000025, req-003: subagent parallelism expansion.
#
# Confirms:
#   1. agent-dispatch-standards.md's MUST-parallelise table has rows for
#      (a) independent new-test-file authoring closing a coverage gap and
#      (b) independent living-doc edits with no shared content.
#   2. The validate-and-accept phase skill keeps its own parallelism
#      guidance (batching and hard sequencing) per the phase-skill
#      parallelism convention.
#   3. None of the pre-existing MUST/Cannot-parallelise rows were removed.
#
# Checks the canonical tracked skill source (ravintio-zero/skills/),
# not the gitignored .claude/skills/ runtime sync copy.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

STANDARDS="$ZERO_DIR/standards/agent-dispatch-standards.md"
VALIDATE_SKILL="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"

grep_has() { grep -q "$1" "$2" 2>/dev/null && echo "yes" || echo "no"; }

echo ""
echo "=== req-003: agent-dispatch-standards.md gains new-test-file pattern ==="

assert_rule piv-dispatch-must-parallel "Independent new test files closing a coverage gap" "non-cross-referencing sections"

echo ""
echo "=== req-003: agent-dispatch-standards.md gains living-doc-edit pattern ==="

assert_rule piv-dispatch-must-parallel "Independent living-doc edits" "no shared content"

echo ""
echo "=== req-003: agent-dispatch-standards.md retains existing MUST/Cannot rows ==="

assert_rule piv-dispatch-must-parallel "Multiple independent codebase searches" "Independent requirement files (no cross-references)"
assert_rule piv-dispatch-cannot-parallel "Phase N work before Phase N-1 artifacts exist" "ADR writing before requirements are complete"

echo ""
echo "=== req-003: validate-and-accept keeps its own parallelism guidance ==="

assert_equals "yes" "$(grep_has '## Parallelism' "$VALIDATE_SKILL")" \
  "req-003: validate-and-accept has a Parallelism section"
assert_rule piv-p3-parallelism "Batch 1 (parallel): lint + typecheck" "library audit + semantic check"

echo ""
echo "=== req-003: hard sequencing unchanged ==="

assert_rule piv-p3-parallelism "Never run tests before typecheck passes" "cycle N+1 before N" \
  "File out-of-scope discoveries to \`plan/backlog/\` per \`ravintio-zero/standards/agent-dispatch-standards.md\`"

print_summary
