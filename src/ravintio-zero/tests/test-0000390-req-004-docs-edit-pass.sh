#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-004: the P3 docs edit pass.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"
TEXT="$(cat "$SKILL")"

echo ""
echo "=== AC-1: the skill names the pass, its scope, and its exclusion ==="
assert_contains "## Docs edit pass" "$TEXT" "the skill has a docs edit pass section"
assert_rule p3-docs-edit-pass "docs/" "README" "changelog" "plan/" "fresh-context" "writing-standards.md"

echo ""
echo "=== AC-2: the linter is the pass condition ==="
assert_rule p3-docs-edit-pass "prose-check.mjs check --files" "ends only when" "ravintio-loop-runner" "docs-edit" "cap of 3" "build log"
assert_rule p3-docs-edit-pass "Skipped: docs edit pass (no user-facing doc changed)"
assert_contains "Docs edit pass result" "$TEXT" "the evidence list names the edit pass result"

echo ""
echo "=== AC-3: size caps hold ==="
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
assert_equals "0" "$([ "$LINES" -le 200 ] && echo 0 || echo 1)" "the skill stays within 200 lines ($LINES)"

print_summary
