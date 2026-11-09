#!/usr/bin/env bash
# Tests for feature 0000393, req-002: forced-add guard, option values and brace groups.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
GUARD="$SCRIPT_DIR/../hooks/enforcement/block-forced-add.mjs"

payload() { node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "$1"; }
# check <label> <expected exit> <command>
check() {
  local out code
  out=$(payload "$3" | node "$GUARD" 2>&1); code=$?
  assert_equals "$2" "$code" "req-002: $1 exits $2"
}

echo "=== req-002: options with a separate value are blocked ==="
check "git-dir with a variable" 2 'F=-f; git --git-dir .git add $F'
check "work-tree with a variable" 2 'F=-f; git --work-tree . add $F'
check "namespace with a variable" 2 'F=-f; git --namespace ns add $F'
check "git-dir with a literal flag" 2 'git --git-dir .git add -f x'
check "work-tree with a literal flag" 2 'git --work-tree . add -f x'
check "namespace with a literal flag" 2 'git --namespace ns add -f x'

echo ""
echo "=== req-002: brace expansion is blocked ==="
check "git add brace expansion" 2 'git add {-f,x}'
check "git stage brace expansion" 2 'git stage {-f,x}'
check "git -C brace expansion" 2 'git -C . add {-f,x}'

echo ""
echo "=== req-002: plain commands pass ==="
check "git add path" 0 'git add src/a.js'
check "git-dir commit message" 0 'git --git-dir .git commit -m "add $V"'
check "attached git-dir" 0 'git --git-dir=.git status'
check "a shell group" 0 '{ git add x; }'
check "a commit message with a variable" 0 'git commit -m "add $VERSION"'
check "a commit message with a braced variable" 0 'git commit -m "add ${VERSION}"'
print_summary
