#!/usr/bin/env bash
# Tests for feature 0000321 REQ-001: priority and theme fields.
# AC-1: the backlog entry template names both fields and their allowed values.
# AC-2: the filing skill names priority, theme, and backlog-index.mjs.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TEMPLATE="$ZERO_DIR/templates/backlog-entry.template.md"
SKILL="$ZERO_DIR/skills/ravintio-file-backlog/SKILL.md"

echo "=== AC-1: template names both fields ==="
FM=$(awk 'NR==1 && /^---$/ {f=1; next} f && /^---$/ {exit} f {print}' "$TEMPLATE")
assert_contains 'priority: "medium"  # high | medium | low' "$FM" "frontmatter holds priority with allowed values"
assert_contains 'theme: "unsorted"  # kebab-case' "$FM" "frontmatter holds theme with its format"
assert_contains "backlog-index.mjs" "$(cat "$TEMPLATE")" "template names the index script"

echo "=== AC-2: filing skill sets both fields ==="
SK=$(cat "$SKILL")
assert_contains "priority" "$SK" "skill names priority"
assert_contains "theme" "$SK" "skill names theme"
assert_contains "backlog-index.mjs" "$SK" "skill names backlog-index.mjs"

print_summary
