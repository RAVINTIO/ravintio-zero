#!/usr/bin/env bash
# Tests for feature 0000204-run-and-initiative-retrospectives, req-001: the
# ravintio-retrospective skill and its record template.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-retrospective/SKILL.md"
TEMPLATE="$ZERO_DIR/templates/retrospective.template.md"

echo ""
echo "=== req-001 AC-1: the skill exists and is short ==="
assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" "req-001 AC-1: the skill file exists"
TEXT=$(cat "$SKILL" 2>/dev/null)
assert_contains "name: ravintio-retrospective" "$TEXT" "req-001 AC-1: frontmatter names the skill"
LINES=$(printf '%s\n' "$TEXT" | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$LINES" -gt 1 ] && [ "$LINES" -lt 120 ] && echo yes || echo no)" "req-001 AC-1: the skill has fewer than 120 lines ($LINES)"

echo ""
echo "=== req-001 AC-2: the skill states the method ==="
assert_rule oa-retro-run-mode "run mode"
assert_rule oa-retro-initiative-mode "initiative mode"
assert_rule oa-retro-blameless "blameless" "person or an agent"
assert_rule oa-retro-run-sources "postmortems" "Rework:"
assert_rule oa-retro-questions "charted steps, bumps, and versions" "friction repeated" "each stop" "tooling gaps"
assert_rule oa-retro-keep-change "one thing to keep and one to change"
assert_rule oa-retro-file-changes "backlog entry or a repo instruction"
assert_rule oa-retro-source-named "source retrospective"

echo ""
echo "=== req-001 AC-3: records live outside the archive ==="
assert_rule oa-retro-records-dir "plan/retrospectives/"
assert_rule oa-retro-no-current "Write nothing under \`plan/current/\`"
TPL=$(cat "$TEMPLATE" 2>/dev/null)
assert_contains "## Keep" "$TPL" "req-001 AC-3: the template has a keep section"
assert_contains "## Change" "$TPL" "req-001 AC-3: the template has a change section"
assert_contains "## Actions" "$TPL" "req-001 AC-3: the template has an actions section"

print_summary
