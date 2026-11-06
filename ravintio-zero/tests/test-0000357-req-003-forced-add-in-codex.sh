#!/usr/bin/env bash
# Tests for feature 0000357-guard-gaps-closed, REQ-003: setup wires the
# forced-add guard into Codex.
#
# setup.sh runs for real in a scratch project. setup.ps1 has no runner here, so
# the PowerShell checks read its text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."

new_project() {
  WS=$(mktemp -d -t ravintio_0000357_req003_XXXXXX)
  cp -r "$ZERO_DIR" "$WS/ravintio-zero"
  git init "$WS" >/dev/null 2>&1
}

# group_count <hooks.json> <module>: Bash groups whose command names the module.
group_count() {
  node -e '
    const h = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).hooks.PreToolUse || [];
    const re = new RegExp("guard " + process.argv[2].replace(".", "\\.") + "( |$)");
    let n = 0;
    for (const g of h) for (const e of g.hooks || []) if (re.test(e.command) && g.matcher === "Bash") n++;
    process.stdout.write(String(n));
  ' "$1" "$2"
}

echo ""
echo "=== REQ-003 AC-1: Codex gets both guards ==="
new_project
OUT="$(cd "$WS" && bash ravintio-zero/setup.sh codex 2>&1)"
assert_equals "1" "$(group_count "$WS/.codex/hooks.json" merge-guard.mjs)" "REQ-003 AC-1: one merge-guard group"
assert_equals "1" "$(group_count "$WS/.codex/hooks.json" block-forced-add.mjs)" "REQ-003 AC-1: one block-forced-add group"
[ -f "$WS/.codex/hooks/enforcement/block-forced-add.mjs" ] && R=yes || R=no
assert_equals "yes" "$R" "REQ-003 AC-1: block-forced-add.mjs is copied"
FA_CMD=$(node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));console.log(s.hooks.PreToolUse.flatMap(g=>g.hooks).map(h=>h.command).filter(c=>c.includes("block-forced-add")).join("\n"))' "$WS/.codex/hooks.json")
assert_contains "$WS/.codex/hooks/enforcement/guard-run.mjs" "$FA_CMD" "REQ-003 AC-1: the command holds the absolute path"
assert_contains " || exit 2" "$FA_CMD" "REQ-003 AC-1: the command fails closed"
printf '%s' '{"tool_name":"Bash","tool_input":{"command":"git stage -f plan/x"}}' | sh -c "$FA_CMD" >/dev/null 2>&1
assert_equals "2" "$?" "REQ-003 AC-1: the wired command blocks a forced stage"

echo ""
echo "=== REQ-003 AC-3: the report lists the guard as active ==="
ACTIVE="$(printf '%s\n' "$OUT" | sed -n '/Active hooks/,/Fallback hooks/p')"
assert_contains "block-forced-add" "$ACTIVE" "REQ-003 AC-3: the report names block-forced-add under active hooks"
FALLBACK="$(printf '%s\n' "$OUT" | sed -n "/Fallback hooks/,/Review and trust/p")"
assert_equals "0" "$(printf '%s\n' "$FALLBACK" | grep -c 'block-forced-add')" "REQ-003 AC-3: the report does not list it as a fallback"
STD="$(cat "$ZERO_DIR/standards/hook-enforcement.md")"
CODEX_SECTION="$(printf '%s\n' "$STD" | sed -n '/^## Codex/,$p' | sed -n '/Active hooks/,/Fallback hooks/p')"
assert_contains "block-forced-add" "$CODEX_SECTION" "REQ-003 AC-3: the standard lists it as an active Codex hook"

echo ""
echo "=== REQ-003 AC-2: a rerun adds no duplicate and keeps a user group ==="
node -e '
  const fs = require("fs");
  const f = process.argv[1];
  const j = JSON.parse(fs.readFileSync(f, "utf8"));
  j.hooks.PreToolUse.push({ matcher: "Bash", hooks: [{ type: "command", command: "echo user-hook" }] });
  fs.writeFileSync(f, JSON.stringify(j));
' "$WS/.codex/hooks.json"
(cd "$WS" && bash ravintio-zero/setup.sh codex >/dev/null 2>&1)
assert_equals "1" "$(group_count "$WS/.codex/hooks.json" merge-guard.mjs)" "REQ-003 AC-2: still one merge-guard group"
assert_equals "1" "$(group_count "$WS/.codex/hooks.json" block-forced-add.mjs)" "REQ-003 AC-2: still one block-forced-add group"
assert_contains "user-hook" "$(cat "$WS/.codex/hooks.json")" "REQ-003 AC-2: the user group stays"
rm -rf "$WS"

echo ""
echo "=== REQ-003: setup.ps1 wires the same guard ==="
PS1="$(cat "$ZERO_DIR/setup.ps1")"
assert_contains "'merge-guard.mjs', 'block-forced-add.mjs', 'read-stdin.mjs', 'guard-run.mjs'" "$PS1" "REQ-003: Install-CodexHooks copies block-forced-add.mjs"
assert_contains "guard block-forced-add.mjs || exit 2" "$PS1" "REQ-003: Install-CodexHooks writes the forced-add command"
assert_contains "block-forced-add (PreToolUse: Bash)" "$PS1" "REQ-003: the PowerShell report lists the guard as active"
print_summary
