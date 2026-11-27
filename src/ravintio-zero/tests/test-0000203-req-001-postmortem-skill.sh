#!/usr/bin/env bash
# Tests for feature 0000203-blameless-postmortems, req-001: the
# ravintio-postmortem skill and its record template.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-postmortem/SKILL.md"
TEMPLATE="$ZERO_DIR/templates/postmortem.template.md"

echo ""
echo "=== req-001 AC-1: the skill exists and is short ==="
assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" "req-001 AC-1: the skill file exists"
TEXT=$(cat "$SKILL" 2>/dev/null)
assert_contains "name: ravintio-postmortem" "$TEXT" "req-001 AC-1: frontmatter names the skill"
LINES=$(printf '%s\n' "$TEXT" | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$LINES" -gt 1 ] && [ "$LINES" -lt 120 ] && echo yes || echo no)" "req-001 AC-1: the skill has fewer than 120 lines ($LINES)"

echo ""
echo "=== req-001 AC-2: the skill states the method ==="
assert_rule oa-pm-triggers "failed CI run" "Blocked:" "self-correction" "escaped defect" "human request"
assert_rule oa-pm-blameless "blameless" "process, check, standard, or tool" "person or an agent"
assert_rule oa-pm-timeline-evidence "timeline"
assert_contains "5 whys" "$(grep '^description:' "$SKILL")" "req-001 AC-2: the 5 whys method"
assert_rule oa-pm-reject-person-chain "person or an agent"
assert_rule oa-pm-action-types "corrective" "preventive" "detective"
assert_rule oa-pm-file-actions "backlog entry or a repo instruction"

echo ""
echo "=== req-001 AC-3: records live outside the archive ==="
assert_rule oa-pm-records-dir "plan/postmortems/"
assert_rule oa-pm-no-current "Write nothing under \`plan/current/\`"
TPL=$(cat "$TEMPLATE" 2>/dev/null)
assert_contains "## Timeline" "$TPL" "req-001 AC-3: the template has a timeline"
assert_contains "## 5 whys" "$TPL" "req-001 AC-3: the template has a 5 whys section"
assert_contains "## Actions" "$TPL" "req-001 AC-3: the template has an actions section"

print_summary
