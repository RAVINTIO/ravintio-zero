#!/usr/bin/env bash
# Tests for feature 0000474-coordinator-shell-guidance, req-001 and req-004: the shell section,
# the skill pointer, and the guards that stay strict.

set -uo pipefail
unset RAVINTIO_INITIATIVE_QUEUE

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/roadmap-standards.md"
SKILL="$ZERO_DIR/skills/ravintio-initiative/SKILL.md"

echo ""
echo "=== req-001 AC-1: the section ==="
SEC="$(sed -n '/^### Coordinator shell tasks/,/^### I-B Activate/p' "$STD")"
assert_contains "rule: coord-shell-tasks" "$SEC" "AC-1: the section carries its rule anchor"
assert_contains "bash" "$SEC" "AC-1: names bash"
assert_contains "Write tool" "$SEC" "AC-1: names the Write tool"
assert_contains 'set -- $x' "$SEC" "AC-1: names the set -- snag"
assert_contains '$b:r' "$SEC" "AC-1: names the :r modifier snag"
assert_contains "replace" "$SEC" "AC-1: names the replace snag"
assert_contains "initiative-queue.mjs drain" "$SEC" "AC-1: names the drain"
assert_contains "bulk-edit.mjs" "$SEC" "AC-1: names the bulk edit"
assert_contains "coordinator-pr-check.mjs" "$SEC" "AC-1: names the overlap check"
assert_contains "merge-guard" "$SEC" "AC-1: says the guards stay strict"

echo ""
echo "=== req-001 AC-2: the skill pointer ==="
assert_contains "coord-shell-tasks" "$(cat "$SKILL")" "AC-2: the skill names the rule"
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
