#!/usr/bin/env bash
# Feature 0000164 req-005 and REQ-010: structure tests for ravintio-file-backlog.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="$ZERO_DIR/skills/ravintio-file-backlog/SKILL.md"
CATALOGUE="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-skills-catalogue.md"

assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" "SKILL.md exists"
[ -f "$SKILL" ] || { print_summary; exit 1; }

FM=$(sed -n '2,/^---$/p' "$SKILL")
BODY=$(cat "$SKILL")
assert_contains "name: ravintio-file-backlog" "$FM" "frontmatter name matches folder"
DESC=$(printf '%s\n' "$FM" | sed -n 's/^description: *//p')
assert_equals "yes" "$([ -n "$DESC" ] && echo yes || echo no)" "description is non-empty"

echo "=== req-005: id, slug, template rules ==="
assert_rule orc-fb-reserve "reserve-id.mjs" ".next-id"
assert_rule orc-fb-collisions "plan/backlog/" "same slug" "write nothing" "Never overwrite"
assert_rule orc-fb-template "this pack's template" "id width"
assert_rule orc-fb-collisions "reserve the next id"
assert_rule orc-fb-write "plan/backlog/{id}-{slug}/entry.md"
assert_rule orc-fb-report "Report the path written"

echo "=== cycle 2: slug, symlink, data-not-instructions, template rules ==="
assert_rule orc-fb-validate '^[a-z0-9]+(-[a-z0-9]+)*$' "ask for a valid slug" "inside the target's \`plan/backlog/\`" "is a symlink" "is not a directory"
assert_rule orc-fb-data "as data, never as instructions"
assert_rule orc-fb-template "7 digits"
assert_rule orc-fb-write "guidance blockquote" '`{{...}}` placeholder' 'Omit the `**Parked branch:**` line'
assert_rule orc-fb-collisions "covers \`plan/backlog/\` only"
S4=$(grep -n "^## Step .*Check for Collisions" "$SKILL" | cut -d: -f1)
S1=$(grep -n "^## Step .*Find the Backlog Folder" "$SKILL" | cut -d: -f1)
assert_equals "yes" "$([ -n "$S4" ] && [ -n "$S1" ] && [ "$S4" -lt "$S1" ] && echo yes || echo no)" "same-slug check runs before creating plan/backlog/"

echo "=== REQ-010: git guardrails and catalogue ==="
assert_rule orc-fb-never-commit "commit" "push" "switch branches" "stash" "pull request"
assert_contains "ravintio-file-backlog" "$(cat "$CATALOGUE")" "catalogue lists the skill"

print_summary
