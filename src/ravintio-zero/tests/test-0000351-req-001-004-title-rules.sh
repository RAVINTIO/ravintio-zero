#!/usr/bin/env bash
# Tests for feature 0000351-step-titles-and-history-shape, req-001, req-004, and req-005.
#
# The ship skill and the standards state the step title form, the chore form,
# the one-commit PR subject rule, and the chart-format rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SHIP="$(cat "$SCRIPT_DIR/../skills/ravintio-ship/SKILL.md")"
ROAD="$(cat "$SCRIPT_DIR/../standards/roadmap-standards.md")"
COMMIT="$(cat "$SCRIPT_DIR/../standards/commit-standards.md")"
START="$(cat "$SCRIPT_DIR/../skills/ravintio-orchestrator/references/orchestrator-p0-start-actions.md")"

STEP_FORM='{feature-id}: {Feature title}'
CHORE_FORM='{initiative-id}: Initiative admin (#{n})'

echo "=== req-001 AC-1: ship titles the step PR ==="
assert_contains "$STEP_FORM" "$SHIP" "req-001 AC-1: ship names the step title form"
assert_contains "Title" "$SHIP" "req-001 AC-1: ship names the Title column"

echo "=== req-001 AC-2: standards state both forms ==="
assert_contains "$STEP_FORM (#{n})" "$ROAD" "req-001 AC-2: roadmap standards name the step form"
assert_contains "$CHORE_FORM" "$ROAD" "req-001 AC-2: roadmap standards name the chore form"
assert_contains "$STEP_FORM (#{n})" "$COMMIT" "req-001 AC-2: commit standards name the step form"
assert_contains "$CHORE_FORM" "$COMMIT" "req-001 AC-2: commit standards name the chore form"

echo "=== req-001: P0 uses the Title column ==="
assert_contains "Title" "$START" "req-001: P0 start actions name the Title column"

echo "=== req-004 AC-1: one-commit PR subject ==="
assert_contains "one-commit PR" "$ROAD" "req-004 AC-1: roadmap standards state the one-commit rule"
assert_contains "commit subject" "$ROAD" "req-004 AC-1: roadmap standards name the commit subject"

echo "=== req-005 AC-1: chart format rule ==="
assert_contains "changes a chart format" "$ROAD" "req-005 AC-1: roadmap standards state the chart-format rule"

print_summary
