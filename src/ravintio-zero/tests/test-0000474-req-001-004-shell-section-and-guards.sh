#!/usr/bin/env bash
# Tests for feature 0000474-coordinator-shell-guidance, req-001 and req-004: the shell section,
# the skill pointer, and the guards that stay strict.

set -uo pipefail
unset RAVINTIO_INITIATIVE_QUEUE

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."

echo ""
echo "=== req-001 AC-1: the section ==="
assert_rule coord-shell-tasks "bash" "Write tool"
assert_rule rm-shell-snags 'set -- $x' '$b:r' "replace"
assert_rule rm-shell-commands-table "initiative-queue.mjs drain" "bulk-edit.mjs" "coordinator-pr-check.mjs"
assert_rule rm-shell-guards "merge-guard"

echo ""
echo "=== req-001 AC-2: the skill pointer ==="
assert_rule orc-init-queue-route "coord-shell-tasks"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "AC-2: skill text $TOTAL <= 1720"

echo ""
echo "=== req-004: the guards stay strict ==="
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin"
cat > "$TMP/bin/gh" <<'STUB'
#!/usr/bin/env bash
if [ "$1 $2" = "pr view" ]; then printf '{"baseRefName":"%s"}\n' "$STUB_BASE"; fi
STUB
chmod +x "$TMP/bin/gh"
payload() { node -e 'console.log(JSON.stringify({tool_name:"Bash",tool_input:{command:process.argv[1]}}))' "$1"; }
FADD="$ZERO_DIR/hooks/enforcement/block-forced-add.mjs"
MGUARD="$ZERO_DIR/hooks/enforcement/merge-guard.mjs"
payload 'git status && git add -f plan' | node "$FADD" >/dev/null 2>&1
assert_equals "2" "$?" "AC-1: a compound forced add exits 2"
payload 'git add "-f" plan' | node "$FADD" >/dev/null 2>&1
assert_equals "2" "$?" "AC-1: a quoted -f exits 2"
payload 'gh pr merge $N --squash' | env PATH="$TMP/bin:$PATH" STUB_BASE=initiative/x node "$MGUARD" >/dev/null 2>&1
assert_equals "2" "$?" "AC-2: a variable merge exits 2"
payload 'echo hi; gh pr merge 5 --squash' | env PATH="$TMP/bin:$PATH" STUB_BASE=main node "$MGUARD" >/dev/null 2>&1
assert_equals "2" "$?" "AC-2: a compound merge into main exits 2"

print_summary
