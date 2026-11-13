#!/usr/bin/env bash
# Tests for feature 0000499-reply-times-match-clock, req-001: the clock hook.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
HOOK="$ZERO_DIR/hooks/enforcement/clock-context.mjs"

echo ""
echo "=== AC-1: the hook returns the current time ==="
OUT=$(RAVINTIO_REPLY_CLOCK=13:42 node "$HOOK" </dev/null 2>/dev/null)
CODE=$?
assert_equals "0" "$CODE" "AC-1: the hook exits 0"
assert_equals "Local time: 13:42" "$(printf '%s' "$OUT" | node -e 'const j=JSON.parse(require("fs").readFileSync(0,"utf8"));console.log(j.hookSpecificOutput.additionalContext)')" "AC-1: additionalContext holds the time"
assert_equals "PostToolUse" "$(printf '%s' "$OUT" | node -e 'console.log(JSON.parse(require("fs").readFileSync(0,"utf8")).hookSpecificOutput.hookEventName)')" "AC-1: the event name is PostToolUse"
OUT=$(env -u RAVINTIO_REPLY_CLOCK node "$HOOK" </dev/null 2>/dev/null)
assert_contains "Local time: " "$OUT" "AC-1: with no override the hook reads the clock"
OUT=$(RAVINTIO_REPLY_CLOCK=nonsense node "$HOOK" </dev/null 2>/dev/null)
assert_equals "0" "$?" "AC-1: a bad override exits 0"
assert_contains "Local time: " "$OUT" "AC-1: a bad override falls back to the clock"

echo ""
echo "=== AC-2: setup wires the hook once and keeps a user entry ==="
post_commands() {
  node -e '
    const s = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    for (const e of (s.hooks && s.hooks.PostToolUse) || []) for (const h of e.hooks || []) console.log(h.command);
  ' "$1"
}
WS=$(mktemp -d -t ravintio_0000499_req001_XXXXXX)
trap 'rm -rf "$WS"' EXIT
cp -r "$ZERO_DIR" "$WS/ravintio-zero"
git init "$WS" >/dev/null 2>&1
commit_workspace_pack "$WS"
mkdir -p "$WS/.claude"
printf '%s\n' '{"hooks":{"PostToolUse":[{"matcher":"Write","hooks":[{"type":"command","command":"node tools/my-note.mjs"}]}]}}' > "$WS/.claude/settings.json"
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
CMDS="$(post_commands "$WS/.claude/settings.json")"
assert_equals "1" "$(printf '%s\n' "$CMDS" | grep -c clock-context)" "AC-2: two runs leave one clock entry"
assert_equals "1" "$(printf '%s\n' "$CMDS" | grep -c my-note)" "AC-2: the user entry survives"
assert_contains 'guard-run.mjs" advisory clock-context.mjs' "$CMDS" "AC-2: the command form is advisory"
P=no; [ -f "$WS/.claude/hooks/enforcement/clock-context.mjs" ] && P=yes
assert_equals "yes" "$P" "AC-2: the hook file is installed"
PS1="$(cat "$ZERO_DIR/setup.ps1")"
assert_contains "clock-context" "$PS1" "AC-2: setup.ps1 names the hook"
assert_contains "PostToolUse" "$PS1" "AC-2: setup.ps1 wires PostToolUse"

echo ""
echo "=== AC-3: the pack lists the hook ==="
assert_contains "clock-context" "$(cat "$ZERO_DIR/scripts/install-lifecycle.mjs")" "AC-3: the lifecycle list names the hook"
FACT=$(node -e '
  const f = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
  const find = (o) => {
    if (Array.isArray(o)) { for (const x of o) { const r = find(x); if (r) return r; } }
    else if (o && typeof o === "object") {
      if (o.module === "clock-context") return o;
      for (const k in o) { const r = find(o[k]); if (r) return r; }
    }
    return null;
  };
  const m = find(f);
  console.log(m ? m.event + " " + m.mode : "none");
' "$ZERO_DIR/pack-facts.json")
assert_equals "PostToolUse advisory" "$FACT" "AC-3: pack-facts names event and mode"

print_summary
