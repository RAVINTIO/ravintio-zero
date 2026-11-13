#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-003: --uninstall.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

new_workspace() {
  local ws
  ws=$(mktemp -d "$TMP/ws_XXXXXX")
  cp -r "$ZERO_DIR" "$ws/ravintio-zero"
  git init "$ws" >/dev/null 2>&1
  commit_workspace_pack "$ws"
  printf '%s\n' "$ws"
}

# Runs setup with the given arguments. Output goes to $ws/out, the exit code is returned.
run_setup() {
  local ws="$1"; shift
  (cd "$ws" && GIT_CEILING_DIRECTORIES="$(dirname "$ws")" bash ravintio-zero/setup.sh "$@" >"$ws/out" 2>&1)
}

install() {
  local ws; ws=$(new_workspace)
  run_setup "$ws" claude-code --strict-orchestrator
  commit_workspace_pack "$ws"
  printf '%s\n' "$ws"
}

echo "=== AC-1: uninstall reverses setup and keeps the developer's entries ==="
ws=$(install)
node -e '
const fs=require("fs");const f=process.argv[1]+"/.claude/settings.json";const s=JSON.parse(fs.readFileSync(f,"utf8"));
s.hooks.PreToolUse.push({matcher:"Bash",hooks:[{type:"command",command:"echo mine"}]});s.myKey=1;
fs.writeFileSync(f,JSON.stringify(s,null,2));' "$ws"
mkdir -p "$ws/.claude/skills/my-own-skill"; echo x > "$ws/.claude/skills/my-own-skill/SKILL.md"
mkdir -p "$ws/.claude/commands"; echo x > "$ws/.claude/commands/my-command.md"
run_setup "$ws" claude-code --uninstall; rc=$?
assert_equals "0" "$rc" "uninstall exits 0"
assert_equals "" "$(git -C "$ws" config --get core.hooksPath)" "core.hooksPath is unset"
settings="$(cat "$ws/.claude/settings.json")"
assert_not_contains ".mjs" "$settings" "no RAVINTIO hook remains in settings.json"
assert_contains "echo mine" "$settings" "the developer's hook survives"
assert_contains "myKey" "$settings" "the developer's key survives"
[ -d "$ws/.claude/skills/my-own-skill" ] && r=yes || r=no
assert_equals "yes" "$r" "the developer's skill survives"
[ -f "$ws/.claude/commands/my-command.md" ] && r=yes || r=no
assert_equals "yes" "$r" "the developer's command survives"
[ -d "$ws/.claude/skills/ravintio-plan" ] && r=yes || r=no
assert_equals "no" "$r" "the pack skill is removed"
assert_contains "removed" "$(cat "$ws/out")" "uninstall prints each change"

echo "=== AC-2: uninstall deletes nothing under plan/ ==="
before="$(cd "$ws" && find plan -type f ! -name '.orchestrator-strict' ! -name '.orchestrator-ack' | LC_ALL=C sort | tr '\n' ' ')"
echo "record" > "$ws/plan/state/own-record.md"
run_setup "$ws" claude-code --uninstall >/dev/null 2>&1
[ -f "$ws/plan/state/own-record.md" ] && r=yes || r=no
assert_equals "yes" "$r" "a plan record survives"
[ -f "$ws/plan/state/claude-code.md" ] && r=yes || r=no
assert_equals "yes" "$r" "the setup record survives"
assert_contains "plan/" "$(cat "$ws/out")" "uninstall lists the plan records"

echo "=== AC-3: uninstall refuses during a run ==="
ws=$(install)
touch "$ws/plan/.orchestrator-active"
run_setup "$ws" claude-code --uninstall; rc=$?
assert_equals "1" "$rc" "uninstall exits 1 while a run is active"
[ -d "$ws/.claude/skills/ravintio-plan" ] && r=yes || r=no
assert_equals "yes" "$r" "nothing changed"
rm "$ws/plan/.orchestrator-active"
touch "$ws/plan/.initiative-runner.lock"
run_setup "$ws" claude-code --uninstall; rc=$?
assert_equals "1" "$rc" "uninstall exits 1 while the driver lock exists"

echo "=== only one lifecycle flag per run ==="
ws=$(install)
run_setup "$ws" claude-code --uninstall --doctor; rc=$?
assert_equals "1" "$rc" "two lifecycle flags exit 1"

print_summary
