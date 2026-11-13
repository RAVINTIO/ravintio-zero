#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-005 AC-3: setup wires the hook.
#
# setup.sh runs for real in a scratch project. The PowerShell side is read from
# source, as the 0000200 suite does.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."

stop_commands() {
  node -e '
    const s = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    for (const e of (s.hooks && s.hooks.Stop) || []) {
      for (const h of e.hooks || []) console.log(h.command);
    }
  ' "$1"
}

new_project() {
  WS=$(mktemp -d -t ravintio_0000390_req005_XXXXXX)
  cp -r "$ZERO_DIR" "$WS/ravintio-zero"
  git init "$WS" >/dev/null 2>&1
  commit_workspace_pack "$WS"
}

echo ""
echo "=== AC-3: setup installs and wires the hook once ==="
new_project
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
(cd "$WS" && bash ravintio-zero/setup.sh claude-code >/dev/null 2>&1)
for f in check-reply-writing.mjs prose-rules.mjs; do
  P=no; [ -f "$WS/.claude/hooks/enforcement/$f" ] && P=yes
  assert_equals "yes" "$P" "AC-3: $f is installed"
done
CMDS="$(stop_commands "$WS/.claude/settings.json")"
assert_equals "1" "$(printf '%s\n' "$CMDS" | grep -c check-reply-writing)" \
  "AC-3: two runs leave one Stop entry for the hook"
assert_equals "1" "$(printf '%s\n' "$CMDS" | grep -c check-reply-prefix)" \
  "AC-3: the prefix hook entry stays single"
assert_contains 'guard-run.mjs" advisory check-reply-writing.mjs' "$CMDS" \
  "AC-3: the command form matches the prefix hook"
rm -rf "$WS"

echo ""
echo "=== AC-3: setup.ps1 wires the same hook ==="
PS1="$(cat "$ZERO_DIR/setup.ps1")"
assert_contains "(New-HookEntry '.*' 'check-reply-writing' \$HooksDir)" "$PS1" "AC-3: setup.ps1 builds the Stop entry"
assert_contains "(check-reply-prefix|check-reply-writing)" "$PS1" "AC-3: setup.ps1 matches both Stop modules on rerun"

echo ""
echo "=== AC-3: the install lifecycle names the hook ==="
assert_contains "check-reply-writing" "$(cat "$ZERO_DIR/scripts/install-lifecycle.mjs")" "AC-3: the lifecycle list names the hook"

print_summary
