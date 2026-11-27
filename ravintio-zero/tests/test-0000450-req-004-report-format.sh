#!/usr/bin/env bash
# Tests for feature 0000450-coordinator-status-view, req-004: the initiative skill
# names the status command and the two report parts, and the standards describe the events.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REPO_DIR="$ZERO_DIR/../.."
INDEX="$(cat "$REPO_DIR/docs/decisions-index.md" 2>/dev/null)"
OVERVIEW="$(cat "$REPO_DIR/docs/architecture-overview.md" 2>/dev/null)"

echo ""
echo "=== req-004 AC-1: the skill names the status command ==="
assert_rule ini-status-before-report "initiative-status.mjs"

echo ""
echo "=== req-004 AC-2: the skill defines the two report parts ==="
assert_rule rm-ini-report-parts "Decisions for the human" "Routine fixes made"
assert_rule ini-status-before-report "I-C Run: event:"

echo ""
echo "=== req-004 AC-3: the standards describe the status view and events ==="
assert_rule rm-status-view "initiative-status.mjs"
assert_rule rm-status-events "driver exited"
assert_rule rm-status-queue-stop "queue stopped on step"

echo ""
echo "=== req-004 AC-4: the living docs describe the status view ==="
assert_contains "adr/0314-coordinator-status-view-and-events.md" "$INDEX" "req-004 AC-4: the decisions index lists the ADR"
assert_contains "initiative-status.mjs" "$OVERVIEW" "req-004 AC-4: the architecture overview names the status script"

print_summary
