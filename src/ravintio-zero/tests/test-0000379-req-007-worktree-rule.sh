#!/usr/bin/env bash
# Tests for feature 0000379-parallel-steps-on-worktrees, REQ-007: the worktree
# rule applies to a human session. The initiative driver may use worktrees.
# AC-1: both boot templates scope the rule.
# AC-2: the custom-001 override carries the same scoped rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
OVERRIDE="$ZERO_DIR/../ravintio-overrides/instructions/custom-001-local-git-only.md"

echo "=== REQ-007 AC-1: boot templates scope the worktree rule ==="
for name in standard-boot codex-boot; do
  TEXT="$(cat "$ZERO_DIR/templates/$name.md")"
  assert_contains "## Worktrees" "$TEXT" "REQ-007 AC-1: $name has a Worktrees section"
  assert_contains "main working tree" "$TEXT" "REQ-007 AC-1: $name says a human session works in the main tree"
  assert_contains "plan/.initiative-worktrees/" "$TEXT" "REQ-007 AC-1: $name lets the driver use worktrees"
done

echo ""
echo "=== REQ-007 AC-2: override carries the scoped rule ==="
OVR="$(cat "$OVERRIDE")"
assert_not_contains "Don't use git worktrees - ensure" "$OVR" "REQ-007 AC-2: override drops the unscoped rule"
assert_contains "human session" "$OVR" "REQ-007 AC-2: override scopes the rule to a human session"
assert_contains "plan/.initiative-worktrees/" "$OVR" "REQ-007 AC-2: override names the driver exception"

print_summary
