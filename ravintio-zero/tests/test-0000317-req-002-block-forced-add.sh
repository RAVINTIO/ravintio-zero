#!/usr/bin/env bash
# Tests for feature 0000317-block-forced-adds, req-002: the forced-add guard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
GUARD="$ZERO_DIR/hooks/enforcement/block-forced-add.mjs"

payload() { node -e 'console.log(JSON.stringify({tool_name:process.argv[2]||"Bash",tool_input:{command:process.argv[1]}}))' "$1" "${2:-Bash}"; }
# check <label> <expected exit> <command> [tool]
check() {
  local out code
  out=$(payload "$3" "${4:-Bash}" | node "$GUARD" 2>&1); code=$?
  assert_equals "$2" "$code" "req-002: $1 exits $2"
  if [ "$2" = "2" ]; then
    assert_contains "block-forced-add" "$out" "req-002: $1 names the guard"
    assert_contains ".gitignore" "$out" "req-002: $1 names the fix"
  fi
}

echo "=== req-002 AC-1: forced forms are blocked ==="
check "git add -f plan" 2 "git add -f plan"
check "git add --force plan" 2 "git add --force plan"
check "git add -fA plan" 2 "git add -fA plan"
check "git add -Af plan" 2 "git add -Af plan"
check "git -C plan add -f x" 2 "git -C plan add -f x"
check "an abbreviated long flag" 2 "git add --forc plan"
check "a quoted flag" 2 'git add "-f" plan'
check "a compound command" 2 "git status && git add -f plan"
check "a newline segment" 2 $'echo ok\ngit add -f plan'

echo ""
echo "=== req-002 AC-2: plain adds are allowed ==="
check "git add plan/current" 0 "git add plan/current"
check "git add -A" 0 "git add -A"
check "git add -n plan" 0 "git add -n plan"
check "git -C dir add file" 0 "git -C plan add current"
check "a forced push" 0 "git push -f origin main"
check "a flag after --" 0 "git add -- -f.txt"
check "a non-Bash tool" 0 "git add -f plan" "Write"
OUT=$(printf 'not json' | node "$GUARD" 2>&1); assert_equals "0" "$?" "req-002: malformed stdin exits 0"

print_summary
