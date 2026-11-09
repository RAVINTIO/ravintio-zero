#!/usr/bin/env bash
# Tests for feature 0000355-codeql-and-branch-cleanup, REQ-002.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SKILL="$SCRIPT_DIR/../skills/ravintio-validate-and-accept/SKILL.md"
ITEM="$(grep -F -- '**Injection points**' "$SKILL")"

echo ""
echo "=== REQ-002: the P3 checklist names incomplete escaping ==="
assert_contains "incomplete escaping" "$ITEM" "REQ-002 AC-1: the injection points item names incomplete escaping"
assert_contains "backslash" "$ITEM" "REQ-002 AC-2: the item gives the backslash example"
print_summary
