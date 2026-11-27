#!/usr/bin/env bash
# Tests for feature 0000321 REQ-004 AC-3: the pickup text and product settings.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REF="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md"
TEMPLATE="$ZERO_DIR/templates/product.template.yml"
PRODUCT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)/product.yml"

echo "=== AC-3: the pickup text ==="
assert_rule p0-start-backlog-pickup 'backlog-index.mjs --review' 'plan/backlog/index.md' 'priority' 'theme' 'node ravintio-zero/scripts/backlog-index.mjs`' 'same commit'

echo "=== backlogReviewDays setting ==="
assert_contains 'backlogReviewDays' "$(cat "$TEMPLATE")" "template documents backlogReviewDays"
assert_equals "1" "$(grep -c '^backlogReviewDays: 5$' "$PRODUCT")" "product.yml sets backlogReviewDays: 5"

print_summary
