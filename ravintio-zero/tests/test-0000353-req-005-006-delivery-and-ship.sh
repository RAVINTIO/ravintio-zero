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


echo "=== req-005 AC-1: standards text ==="
assert_rule rm-delivery-reshape-command 'reshape-initiative.mjs' '--assign' '--tags' '--push'
assert_rule rm-delivery-reshape-branch '-reshaped' 'never force-pushes a branch or a tag'
assert_rule rm-delivery-reshape-push 'deletes each old tag on `origin`'
assert_rule rm-delivery-report 'delete the old branch'
assert_rule rm-delivery-pr-title 'Close any PR from the old branch'
assert_rule rm-delivery-reshape-conflict 'drop no hunk'

echo "=== req-005 AC-2: skill text and size ==="
assert_rule rm-ini-delivery 'reshape-initiative.mjs' 'delete the old branch'
LINES="$(wc -l < "$SKILL" | tr -d ' ')"
[ "$LINES" -lt 120 ] && R=ok || R=long
assert_equals "ok" "$R" "AC-2: initiative skill stays under 120 lines"

echo "=== req-006 AC-1: no lease ==="
assert_not_contains '--force-with-lease' "$(cat "$SHIP")" "AC-1: ship skill has no --force-with-lease"

echo "=== req-006 AC-2: route and bans ==="
assert_rule shp-main-replacement-pr 'chore/*'
assert_rule shp-main-no-force-push 'chore/*'

print_summary
