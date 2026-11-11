#!/usr/bin/env bash
# Tests for feature 0000450-coordinator-status-view, req-004: the initiative skill
# names the status command and the two report parts, and the standards describe the events.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$(cat "$ZERO_DIR/skills/ravintio-initiative/SKILL.md" 2>/dev/null)"
STANDARDS="$(cat "$ZERO_DIR/standards/roadmap-standards.md" 2>/dev/null)"
REPO_DIR="$ZERO_DIR/../.."
INDEX="$(cat "$REPO_DIR/docs/decisions-index.md" 2>/dev/null)"
OVERVIEW="$(cat "$REPO_DIR/docs/architecture-overview.md" 2>/dev/null)"

echo ""
echo "=== req-004 AC-1: the skill names the status command ==="
assert_contains "initiative-status.mjs" "$SKILL" "req-004 AC-1: the skill names initiative-status.mjs"

echo ""
echo "=== req-004 AC-2: the skill defines the two report parts ==="
assert_contains "Decisions for you" "$SKILL" "req-004 AC-2: Decisions for you"
assert_contains "Routine fixes made" "$SKILL" "req-004 AC-2: Routine fixes made"
assert_contains "I-C Run: event:" "$SKILL" "req-004 AC-2: the skill relays watcher events"

echo ""
echo "=== req-004 AC-3: the standards describe the status view and events ==="
assert_contains "initiative-status.mjs" "$STANDARDS" "req-004 AC-3: the standards name the status command"
assert_contains "driver exited" "$STANDARDS" "req-004 AC-3: the standards name the driver exit event"
assert_contains "queue stopped on step" "$STANDARDS" "req-004 AC-3: the standards name the queue stop line"

echo ""
echo "=== req-004 AC-4: the living docs describe the status view ==="
assert_contains "adr/0314-coordinator-status-view-and-events.md" "$INDEX" "req-004 AC-4: the decisions index lists the ADR"
assert_contains "initiative-status.mjs" "$OVERVIEW" "req-004 AC-4: the architecture overview names the status script"

print_summary
