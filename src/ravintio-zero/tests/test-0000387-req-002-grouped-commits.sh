#!/usr/bin/env bash
# Test: 0000387 req-002 grouped-commits
# Coaching records group into one commit per topic. Artifacts and end-of-session
# records still commit at once. The boot template points to the grouping rule.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== AC-1: grouping rule ==="
assert_rule records-group-by-topic "one commit per topic" "Scope Lock" "audit trail" "closes" "pauses"

echo "=== AC-2: immediate commits ==="
assert_rule records-commit-at-once "requirement" "ADR" "design.md" "at once" "may end" "one topic"

echo "=== AC-3: boot template pointer ==="
BOOT="$_ASSERT_PACK_ROOT/templates/standard-boot.md"
BOOT_TEXT="$(cat "$BOOT")"
assert_contains "references/orchestrator-discovery-records.md" "$BOOT_TEXT" "boot template points to the discovery records reference"
assert_contains "by topic" "$BOOT_TEXT" "boot template says coaching records group by topic"

print_summary
