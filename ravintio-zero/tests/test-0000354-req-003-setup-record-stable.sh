#!/usr/bin/env bash
# Tests for feature 0000354-steps-run-to-the-end, req-003: setup leaves the tracked record
# plan/state/{tool}.md unchanged when only writtenAt would change.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SETUP_SH="$ZERO_DIR/setup.sh"
SETUP_PS1="$ZERO_DIR/setup.ps1"

make_workspace() {
  local dir
  dir=$(mktemp -d -t ravintio_0000354_req003_test_XXXXXX)
  cp -r "$ZERO_DIR" "$dir/ravintio-zero"
  git init "$dir" >/dev/null 2>&1
  git config --global --add safe.directory "$dir" >/dev/null 2>&1 || true
  echo "$dir"
}

echo ""
echo "=== req-003 AC-1: a rerun leaves the committed record clean ==="
WS=$(make_workspace); cd "$WS"
bash ravintio-zero/setup.sh claude-code --strict-orchestrator >/dev/null 2>&1
git add plan/state/claude-code.md
git -c user.email=t@example.com -c user.name=t commit -q -m "record" >/dev/null 2>&1
FIRST_MARKER="$(grep writtenAt .claude/.ravintio-setup-flags)"
sleep 1
RERUN="$(bash ravintio-zero/setup.sh claude-code --strict-orchestrator 2>&1)"
assert_exit_zero $? "AC-1: the rerun exits 0"
assert_equals "" "$(git status --porcelain -- plan/state)" "AC-1: git status is clean for plan/state"
assert_contains "= plan/state/claude-code.md (unchanged)" "$RERUN" "AC-1: setup says the record is unchanged"
assert_equals "yes" "$([ "$FIRST_MARKER" = "$(grep writtenAt .claude/.ravintio-setup-flags)" ] && echo no || echo yes)" "AC-1: the ignored marker keeps a fresh timestamp"

echo ""
echo "=== req-003 AC-2: a flag change rewrites the record ==="
CHANGED="$(bash ravintio-zero/setup.sh claude-code 2>&1)"
assert_contains "+ plan/state/claude-code.md" "$CHANGED" "AC-2: setup says it wrote the record"
assert_equals "M" "$(git status --porcelain -- plan/state | cut -c2)" "AC-2: the record shows as modified"
assert_contains '"flags": []' "$(cat plan/state/claude-code.md)" "AC-2: the record holds the new flags"
cd "$SCRIPT_DIR"; rm -rf "$WS"

echo ""
echo "=== req-003 AC-3: setup.ps1 holds the same compare and message ==="
PS="$(cat "$SETUP_PS1")"
assert_contains "(unchanged)" "$PS" "AC-3: setup.ps1 prints the unchanged message"
assert_contains "= plan/state/\$ToolName.md" "$PS" "AC-3: setup.ps1 names the record in the message"
assert_contains "= plan/state/" "$(cat "$SETUP_SH")" "AC-3: setup.sh prints the same prefix"

print_summary
