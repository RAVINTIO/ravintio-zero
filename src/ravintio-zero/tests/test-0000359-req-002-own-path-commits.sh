#!/usr/bin/env bash
# Tests for feature 0000359-safe-parallel-commits, req-002: the dispatch standard
# tells each unit to commit with its own paths and bans amend in a batch.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

STD="$SCRIPT_DIR/../standards/agent-dispatch-standards.md"

echo ""
echo "=== req-002 AC-1: the path-limited commit form ==="
assert_rule ob-batch-commit-paths "git commit -m \"{message}\" -- {paths}"

echo ""
echo "=== req-002 AC-2: the amend ban ==="
assert_rule ob-batch-no-amend "Never run \`git commit --amend\`" "new commit"

echo ""
echo "=== req-002 AC-3: the earlier rules stay ==="
assert_rule ob-batch-stage-by-path "git add -A"
assert_rule ob-batch-no-stash "Never run \`git stash\`"

print_summary
