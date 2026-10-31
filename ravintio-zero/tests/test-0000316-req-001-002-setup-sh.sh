#!/usr/bin/env bash
# Tests for feature 0000316-hooks-fail-closed, req-001 and req-002: setup.sh keeps
# Bash in the project root and wires every hook from the project root.
#
# setup.sh is run for real in a scratch project. setup.ps1 has no runner here,
# so test-0000316-req-001-002-setup-ps1.ps1 covers it where pwsh exists.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."

new_project() {
  WS=$(mktemp -d -t ravintio_0000316_setup_XXXXXX)
  cp -r "$ZERO_DIR" "$WS/ravintio-zero"
  git init "$WS" >/dev/null 2>&1
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
echo "=== req-001: the env setting ==="
new_project
mkdir -p "$WS/.claude"
printf '%s\n' '{"env":{"FOO":"bar"}}' > "$WS/.claude/settings.json"
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
ENVV=$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));console.log(s.env.CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR+"|"+s.env.FOO)' "$WS/.claude/settings.json")
assert_equals "1|bar" "$ENVV" "req-001 AC-1, AC-2: the setting is 1 and FOO survives"
SUM1=$(cksum < "$WS/.claude/settings.json")
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
SUM2=$(cksum < "$WS/.claude/settings.json")
assert_equals "$SUM1" "$SUM2" "req-001 AC-3: a rerun leaves settings.json unchanged"
rm -rf "$WS"

new_project
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
assert_contains "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR" "$(cat "$WS/.claude/settings.json")" "req-001 AC-1: a fresh install writes the setting"

echo ""
echo "=== req-002: hook commands use the project root ==="
CMDS="$(hook_commands "$WS/.claude/settings.json")"
assert_equals "0" "$(printf '%s\n' "$CMDS" | grep -c -F 'node ".claude/')" "req-002: no command is relative to the working directory"
assert_equals "0" "$(printf '%s\n' "$CMDS" | grep -v -c -F 'CLAUDE_PROJECT_DIR')" "req-002: every command reads CLAUDE_PROJECT_DIR"
assert_equals "8" "$(printf '%s\n' "$CMDS" | grep -c -F ' guard ')" "req-002: eight PreToolUse commands run in guard mode"
assert_equals "4" "$(printf '%s\n' "$CMDS" | grep -c -F ' advisory ')" "req-002: four commands run in advisory mode"

# AC-1: every command runs from a subfolder and exits like its script.
mkdir -p "$WS/ravintio-zero/sub"
BAD=0
while IFS= read -r cmd; do
  [ -n "$cmd" ] || continue
  ERR=$(cd "$WS/ravintio-zero/sub" && printf '%s' '{"tool_name":"Read","tool_input":{}}' | CLAUDE_PROJECT_DIR="$WS" bash -c "$cmd" 2>&1 >/dev/null); CODE=$?
  if [ "$CODE" -ne 0 ] || printf '%s' "$ERR" | grep -q 'MODULE_NOT_FOUND'; then BAD=$((BAD+1)); echo "    failing: $cmd -> $CODE $ERR"; fi
done <<< "$CMDS"
assert_equals "0" "$BAD" "req-002 AC-1: every hook command runs from a subfolder"

# A guard whose script is gone blocks and names the script.
rm -f "$WS/.claude/hooks/enforcement/gate-write.mjs"
GATE_CMD=$(printf '%s\n' "$CMDS" | grep -F 'gate-write.mjs' | head -1)
ERR=$(cd "$WS/ravintio-zero/sub" && printf '%s' '{}' | CLAUDE_PROJECT_DIR="$WS" bash -c "$GATE_CMD" 2>&1 >/dev/null); CODE=$?
assert_equals "2" "$CODE" "req-003: the wired gate-write command exits 2 once its script is gone"
assert_contains "gate-write.mjs" "$ERR" "req-003: the message names the script"
rm -rf "$WS"

echo ""
echo "=== req-002 AC-3: old relative commands are replaced ==="
new_project
mkdir -p "$WS/.claude"
printf '%s\n' '{"hooks":{"PreToolUse":[{"matcher":"Write","hooks":[{"type":"command","command":"node \".claude/hooks/enforcement/gate-write.mjs\""}]}]}}' > "$WS/.claude/settings.json"
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
CMDS="$(hook_commands "$WS/.claude/settings.json")"
assert_equals "2" "$(printf '%s\n' "$CMDS" | grep -c -F 'gate-write.mjs')" "req-002 AC-3: gate-write appears for Write and Edit only"
assert_equals "0" "$(printf '%s\n' "$CMDS" | grep -c -F 'node ".claude/')" "req-002 AC-3: the old relative command is gone"
rm -rf "$WS"

echo ""
echo "=== req-002 AC-2: Codex uses the absolute project path ==="
new_project
(cd "$WS" && bash ravintio-zero/setup.sh codex >/dev/null 2>&1)
CODEX_CMD=$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));console.log(s.hooks.PreToolUse.flatMap(g=>g.hooks).map(h=>h.command).join("\n"))' "$WS/.codex/hooks.json")
REAL_WS="$WS"
assert_contains "$REAL_WS/.codex/hooks/enforcement/guard-run.mjs" "$CODEX_CMD" "req-002 AC-2: the command holds the absolute path"
assert_equals "0" "$(printf '%s\n' "$CODEX_CMD" | grep -c 'rev-parse')" "req-002 AC-2: the command has no git rev-parse"
[ -f "$WS/.codex/hooks/enforcement/guard-run.mjs" ] && R=yes || R=no
assert_equals "yes" "$R" "req-002 AC-2: guard-run.mjs is copied for Codex"
(cd "$WS" && bash ravintio-zero/setup.sh codex >/dev/null 2>&1)
assert_equals "1" "$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));console.log(s.hooks.PreToolUse.flatMap(g=>g.hooks).length)' "$WS/.codex/hooks.json")" "req-002 AC-3: a Codex rerun leaves one hook"
rm -rf "$WS"

print_summary
