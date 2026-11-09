#!/usr/bin/env bash
# Tests for feature 0000318-titled-coordinator-prs, req-003 AC-1: the ship
# skill records the PR number before the squash.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SHIP="$SCRIPT_DIR/../skills/ravintio-ship/SKILL.md"

section() {
  awk -v h="$1" '
    $0 == h { on = 1; lvl = index(h, " "); next }
    on && /^#+ / { if (index($0, " ") <= lvl) exit }
    on { print }' "$2"
}
has() { printf '%s\n' "$2" | grep -qF -- "$1" && echo yes || echo no; }

echo ""
echo "=== req-003 AC-1: ship orders the PR number before the squash ==="

INIT="$(section '## Initiative steps' "$SHIP")"
assert_equals "yes" "$(has 'sets `**PR:**` to the PR number, commits, and pushes it before it waits on CI and before the squash' "$INIT")" \
  "AC-1: initiative steps commit and push the PR number before CI and the squash"
assert_equals "yes" "$(has 'never commits after the squash' "$INIT")" \
  "AC-1: the agent never commits after the squash"
assert_equals "yes" "$(has 'merge --squash --delete-branch {n}' "$INIT")" \
  "AC-1: the merge line stays"

print_summary
