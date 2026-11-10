#!/usr/bin/env bash
# Tests for feature 0000357-guard-gaps-closed, REQ-001: a guard hook command
# exits 2 when guard-run.mjs is missing.
#
# setup.sh runs for real in a scratch project. setup.ps1 has no runner here, so
# the PowerShell checks read its text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SUFFIX=' || exit 2'

new_project() {
  WS=$(mktemp -d -t ravintio_0000357_req001_XXXXXX)
  cp -r "$ZERO_DIR" "$WS/ravintio-zero"
  git init "$WS" >/dev/null 2>&1
  commit_workspace_pack "$WS"
}

# hook_commands <settings>: prints every hook command, one per line.
hook_commands() {
  node -e '
    const s = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    for (const ev of Object.keys(s.hooks || {}))
      for (const e of s.hooks[ev]) for (const h of e.hooks || []) console.log(h.command);
  ' "$1"
}

echo ""
echo "=== REQ-001 AC-1: a missing launcher blocks every guard command ==="
new_project
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
CMDS="$(hook_commands "$WS/.claude/settings.json")"
GUARDS="$(printf '%s\n' "$CMDS" | grep -F ' guard ')"
ADVISORY="$(printf '%s\n' "$CMDS" | grep -F ' advisory ')"
assert_equals "9" "$(printf '%s\n' "$GUARDS" | grep -c .)" "REQ-001: nine guard commands are wired"
assert_equals "9" "$(printf '%s\n' "$GUARDS" | grep -c -F -e "$SUFFIX" | tr -d ' ')" "REQ-001: each guard command ends with the suffix"
assert_equals "0" "$(printf '%s\n' "$ADVISORY" | grep -c -F -e "$SUFFIX")" "REQ-001 AC-3: no advisory command has the suffix"

rm -f "$WS/.claude/hooks/enforcement/guard-run.mjs"
BAD=0
while IFS= read -r cmd; do
  [ -n "$cmd" ] || continue
  printf '%s' '{"tool_name":"Read","tool_input":{}}' | CLAUDE_PROJECT_DIR="$WS" sh -c "$cmd" >/dev/null 2>&1
  CODE=$?
  if [ "$CODE" -ne 2 ]; then BAD=$((BAD+1)); echo "    exit $CODE: $cmd"; fi
done <<< "$GUARDS"
assert_equals "0" "$BAD" "REQ-001 AC-1: every guard command exits 2 with the launcher removed"
rm -rf "$WS"

echo ""
echo "=== REQ-001 AC-2: the launcher result passes through ==="
new_project
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
CMDS="$(hook_commands "$WS/.claude/settings.json")"
MERGE_CMD="$(printf '%s\n' "$CMDS" | grep -F 'merge-guard.mjs' | head -1)"
printf '%s' '{"tool_name":"Bash","tool_input":{"command":"git status"}}' | CLAUDE_PROJECT_DIR="$WS" sh -c "$MERGE_CMD" >/dev/null 2>&1
assert_equals "0" "$?" "REQ-001 AC-2: an allowed call exits 0"
printf '%s' '{"tool_name":"Bash","tool_input":{"command":"gh pr merge 5 --squash"}}' | CLAUDE_PROJECT_DIR="$WS" sh -c "$MERGE_CMD" >/dev/null 2>&1
assert_equals "2" "$?" "REQ-001 AC-2: a blocked call still exits 2"
rm -rf "$WS"

echo ""
echo "=== REQ-001: Codex commands end with the suffix ==="
new_project
(cd "$WS" && bash ravintio-zero/setup.sh codex >/dev/null 2>&1)
CODEX_CMDS=$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));console.log(s.hooks.PreToolUse.flatMap(g=>g.hooks).map(h=>h.command).join("\n"))' "$WS/.codex/hooks.json")
assert_equals "0" "$(printf '%s\n' "$CODEX_CMDS" | grep -v -c -F -e "$SUFFIX")" "REQ-001: every Codex command ends with the suffix"
rm -rf "$WS"

echo ""
echo "=== REQ-001 AC-3: setup.ps1 writes the same suffix ==="
PS1="$(cat "$ZERO_DIR/setup.ps1")"
assert_contains "guard-run.mjs\" ' + \$mode + ' ' + \$Module + '.mjs' + \$suffix" "$PS1" "REQ-001 AC-3: New-HookEntry appends the suffix variable"
assert_contains "if (\$mode -eq 'guard') { ' || exit 2' } else { '' }" "$PS1" "REQ-001 AC-3: the suffix applies in guard mode only"
assert_contains "guard merge-guard.mjs || exit 2" "$PS1" "REQ-001 AC-3: the Codex command ends with the suffix"
print_summary
