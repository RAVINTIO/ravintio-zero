#!/usr/bin/env bash
# 0000353 req-005 and req-006: the delivery rules and the initiative skill name the reshape,
# and the ship skill allows no force push with a lease.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$ZERO_DIR/standards/roadmap-standards.md"
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

DEL="$(awk '$0 == "### I-E Delivery" {on=1; next} on && /^###? / {exit} on {print}' "$STD")"
SKILL_DEL="$(awk '$0 == "## I-E Delivery" {on=1; next} on && /^## / {exit} on {print}' "$SKILL")"
SEC="$(awk '$0 == "## PRs into main" {on=1; next} on && /^## / {exit} on {print}' "$SHIP")"

echo "=== req-005 AC-1: standards text ==="
assert_contains 'reshape-initiative.mjs' "$DEL" "AC-1: names the script"
assert_contains '-reshaped' "$DEL" "AC-1: names the reshaped branch"
assert_contains '--assign' "$DEL" "AC-1: names the assign option"
assert_contains '--tags' "$DEL" "AC-1: names the tags option"
assert_contains '--push' "$DEL" "AC-1: names the push option"
assert_contains 'deletes each old tag on `origin`' "$DEL" "AC-1: names the old tag delete"
assert_contains 'delete the old branch' "$DEL" "AC-1: names the old branch delete"
assert_contains 'Close any PR from the old branch' "$DEL" "AC-1: closes the old PR"
assert_contains 'never force-pushes a branch or a tag' "$DEL" "AC-1: no force push"
assert_contains 'drop no hunk' "$DEL" "AC-1: stops on a conflict"

echo "=== req-005 AC-2: skill text and size ==="
assert_contains 'reshape-initiative.mjs' "$SKILL_DEL" "AC-2: skill names the script"
assert_contains 'delete the old branch' "$SKILL_DEL" "AC-2: skill names the cleanup"
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "AC-2: initiative skill stays under 120 lines"

echo "=== req-006 AC-1: no lease ==="
assert_not_contains '--force-with-lease' "$SEC" "AC-1: ship section has no --force-with-lease"
assert_not_contains '--force-with-lease' "$(cat "$SHIP")" "AC-1: ship skill has no --force-with-lease"

echo "=== req-006 AC-2: route and bans ==="
assert_contains 'chore/*' "$(printf '%s\n' "$SEC" | grep 'replacement PR')" "AC-2: replacement route names chore/*"
assert_contains 'chore/*' "$(printf '%s\n' "$SEC" | grep 'never force-push')" "AC-2: never force-push names chore/*"

print_summary
