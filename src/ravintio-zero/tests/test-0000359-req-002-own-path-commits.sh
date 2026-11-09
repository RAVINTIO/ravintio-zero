#!/usr/bin/env bash
# Tests for feature 0000359-safe-parallel-commits, req-002: the dispatch standard
# tells each unit to commit with its own paths and bans amend in a batch.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$SCRIPT_DIR/../standards/agent-dispatch-standards.md"
BATCH=$(awk '/^## Fast batches/{f=1;next} /^## /{f=0} f' "$STD")

echo ""
echo "=== req-002 AC-1: the path-limited commit form ==="
assert_contains "git commit -m \"{message}\" -- {paths}" "$BATCH" "req-002 AC-1: the commit form"

echo ""
echo "=== req-002 AC-2: the amend ban ==="
assert_contains "Never run \`git commit --amend\`" "$BATCH" "req-002 AC-2: amend is forbidden"
assert_contains "new commit" "$BATCH" "req-002 AC-2: a fix is a new commit"

echo ""
echo "=== req-002 AC-3: the earlier rules stay ==="
assert_contains "git add -A" "$BATCH" "req-002 AC-3: stage by path stays"
assert_contains "Never run \`git stash\`" "$BATCH" "req-002 AC-3: no stash stays"

print_summary
