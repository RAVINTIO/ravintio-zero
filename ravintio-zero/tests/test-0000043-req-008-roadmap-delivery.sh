#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-008: roadmap delivery.
#
# After the last step, I-E Delivery archives plan/current-initiative/ and raises
# one initiative PR to main that asks for a merge commit. The agent never merges
# it and never commits to main.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/pipeline-reference.md"

section() { awk -v h="$1" '$0 == h {on=1; next} on && /^##? / {exit} on {print}' "$2"; }

echo ""
echo "=== req-008 (a): archive the initiative folder, status delivered ==="
assert_rule rm-delivery-intro 'I-E Delivery:' 'last step' 'initiative branch'
assert_rule rm-delivery-steps 'plan/current-initiative/' 'plan/_archive/{id}-{slug}-initiative-{date}/' '`status: delivered`'

echo ""
echo "=== req-008 (b): one PR to main asking for a merge commit ==="
assert_rule rm-delivery-pr-command 'gh pr create --base main' '--head initiative/{id}-{slug}'
assert_rule rm-delivery-pr-title 'merge commit'
assert_rule rm-delivery-pr-body 'merge commit' 'not a squash' 'version and tag'

echo ""
echo "=== req-008 (c): never merge the initiative PR, never commit to main ==="
assert_rule rm-delivery-never-merge 'never merges the initiative PR' 'never commits to `main`'
assert_rule rm-ship-stages-step 'merge-guard'

echo ""
echo "=== req-008: pipeline reference records delivery ==="
SHIPREF="$(section '## Ship Phase' "$REF")"
assert_contains 'merge commit' "$SHIPREF" "req-008: pipeline reference asks for a merge commit"

print_summary
