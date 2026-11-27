#!/usr/bin/env bash
# Tests for feature 0000351-step-titles-and-history-shape, req-001, req-004, and req-005.
#
# The ship skill and the standards state the step title form, the chore form,
# the one-commit PR subject rule, and the chart-format rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STEP_FORM='{feature-id}: {Feature title}'
CHORE_FORM='{initiative-id}: Initiative admin (#{n})'

echo "=== req-001 AC-1: ship titles the step PR ==="
assert_rule shp-pr-title-body "$STEP_FORM" "Title"

echo "=== req-001 AC-2: standards state both forms ==="
assert_rule rm-commit-titles-table "$STEP_FORM (#{n})" "$CHORE_FORM"
assert_rule rm-commit-step-form "$STEP_FORM (#{n})"
assert_rule rm-commit-chore-form "$CHORE_FORM"

echo "=== req-001: P0 uses the Title column ==="
assert_rule p0-start-backlog-pickup "Title"

echo "=== req-004 AC-1: one-commit PR subject ==="
assert_rule rm-coord-one-commit "one-commit PR" "commit subject"

echo "=== req-005 AC-1: chart format rule ==="
assert_rule rm-commit-chart-format "changes a chart format"

print_summary
