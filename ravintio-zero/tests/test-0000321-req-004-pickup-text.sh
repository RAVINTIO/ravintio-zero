#!/usr/bin/env bash
# Tests for feature 0000321 REQ-004 AC-3: the pickup text and product settings.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REF="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md"
TEMPLATE="$ZERO_DIR/templates/product.template.yml"
PRODUCT="$ZERO_DIR/../product.yml"

STEP=$(grep -A6 -E "^10\. " "$REF")

echo "=== AC-3: step 10 pickup text ==="
assert_contains 'backlog-index.mjs --review' "$STEP" "step 10 names the review mode"
assert_contains 'plan/backlog/index.md' "$STEP" "step 10 names the index"
assert_contains 'priority' "$STEP" "step 10 names priority order"
assert_contains 'theme' "$STEP" "step 10 names theme order"
assert_contains 'node ravintio-zero/scripts/backlog-index.mjs`' "$STEP" "step 10 names the regenerate command"
assert_contains 'same commit' "$STEP" "step 10 regenerates the index in the same commit"

echo "=== backlogReviewDays setting ==="
assert_contains 'backlogReviewDays' "$(cat "$TEMPLATE")" "template documents backlogReviewDays"
assert_equals "1" "$(grep -c '^backlogReviewDays: 5$' "$PRODUCT")" "product.yml sets backlogReviewDays: 5"

print_summary
