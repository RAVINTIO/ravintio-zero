#!/usr/bin/env bash
# Tests for feature 0000355-codeql-and-branch-cleanup, REQ-005.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENTRY="$(cat "$ROOT"/plan/backlog/0000323-*/entry.md 2>/dev/null)"

echo ""
echo "=== REQ-005: entry 0000323 matches the repo ==="
ROW="$(printf '%s\n' "$ENTRY" | grep -F 'Code scanning' | head -1)"
assert_contains ".github/workflows/codeql.yml" "$ROW" "REQ-005 AC-1: the code scanning row names the workflow"
assert_not_contains "Automatically delete head branches" "$ENTRY" "REQ-005 AC-2: the deletion item is gone"
print_summary
