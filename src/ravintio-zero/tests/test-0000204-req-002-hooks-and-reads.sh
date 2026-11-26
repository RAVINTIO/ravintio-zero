#!/usr/bin/env bash
# Tests for feature 0000204-run-and-initiative-retrospectives, req-002: the
# ship and delivery hooks, and the P0 and chart reads.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
CATALOGUE="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-skills-catalogue.md"
DELIVERY="$(orch_section '### I-E Delivery')"
echo ""
echo "=== req-002 AC-1: ship writes the run retrospective ==="
assert_rule rm-ship-retro "ravintio-retrospective" "run mode" "plan/retrospectives/" "Retrospective:"

echo ""
echo "=== req-002 AC-2: delivery writes the initiative retrospective ==="
assert_rule rm-delivery-steps "ravintio-retrospective" "initiative mode"
ARCHIVE_LINE=$(printf '%s\n' "$DELIVERY" | grep -n 'Move `plan/current-initiative/`' | head -1 | cut -d: -f1)
RETRO_LINE=$(printf '%s\n' "$DELIVERY" | grep -n 'initiative mode' | head -1 | cut -d: -f1)
PR_LINE=$(printf '%s\n' "$DELIVERY" | grep -n 'gh pr create' | head -1 | cut -d: -f1)
assert_equals "yes" "$([ -n "$ARCHIVE_LINE" ] && [ -n "$RETRO_LINE" ] && [ -n "$PR_LINE" ] && [ "$ARCHIVE_LINE" -lt "$RETRO_LINE" ] && [ "$RETRO_LINE" -lt "$PR_LINE" ] && echo yes || echo no)" "req-002 AC-2: the record comes after the archive and before the PR"
assert_rule rm-delivery-pr-body "retrospective"

echo ""
echo "=== req-002 AC-3: P0 and chart read past records ==="
assert_rule rm-p0-retro-read "plan/retrospectives/"
assert_rule rm-chart-retro-read "plan/retrospectives/"
assert_contains "| ravintio-retrospective |" "$(cat "$CATALOGUE")" "req-002 AC-3: the catalogue has a row"

echo ""
echo "=== req-002 AC-4: neither stage blocks on a missing record ==="
assert_rule rm-ship-retro "never block"
assert_rule rm-delivery-steps "never block"

print_summary
