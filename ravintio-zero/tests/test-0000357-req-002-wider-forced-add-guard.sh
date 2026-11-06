#!/usr/bin/env bash
# Tests for feature 0000357-guard-gaps-closed, REQ-002: the wider forced-add guard.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
GUARD="$SCRIPT_DIR/../hooks/enforcement/block-forced-add.mjs"

payload() { node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "$1"; }
# check <label> <expected exit> <command>
check() {
  local out code
  out=$(payload "$3" | node "$GUARD" 2>&1); code=$?
  assert_equals "$2" "$code" "REQ-002: $1 exits $2"
}

echo "=== REQ-002 AC-1: each widened form is blocked ==="
check "git stage -f" 2 "git stage -f plan/x"
check "a subshell" 2 "(git add -f plan/x)"
check "a command substitution" 2 'echo $(git add -f plan/x)'
check "a backtick substitution" 2 'echo `git add -f plan/x`'
check "a braced group" 2 "{ git add -f plan/x; }"
check "a flag in a variable" 2 'F=-f; git add $F plan/x'
check "a braced variable" 2 'F=-f; git add "${F}" plan/x'
check "a variable in git stage" 2 'F=-f; git stage $F plan/x'

echo ""
echo "=== REQ-002 AC-2: plain adds pass ==="
check "git add path" 0 "git add src/a.js"
check "git stage path" 0 "git stage src/a.js"
check "a subshell with a plain add" 0 "(git add src/a.js)"
check "a variable with no git add" 0 'echo $HOME && git status'

echo ""
echo "=== REQ-002 AC-3: existing forms stay blocked ==="
check "git add -f" 2 "git add -f x"
check "git add --force" 2 "git add --force x"
check "git -C dir add -fA" 2 "git -C dir add -fA x"
print_summary
