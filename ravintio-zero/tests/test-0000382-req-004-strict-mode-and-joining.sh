#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-004: strict mode follows the flags and the guide has a joining section.

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

echo "=== AC-1: strict mode follows the flags ==="
ws=$(new_workspace)
run_setup "$ws" claude-code --strict-orchestrator
commit_workspace_pack "$ws"
run_setup "$ws" claude-code --strict-orchestrator
[ -f "$ws/plan/.orchestrator-strict" ] && r=yes || r=no
assert_equals "yes" "$r" "a re-run with the flag keeps strict mode"
run_setup "$ws" claude-code
[ -f "$ws/plan/.orchestrator-strict" ] && r=yes || r=no
assert_equals "yes" "$r" "a plain re-run keeps strict mode"
assert_contains '"--strict-orchestrator"' "$(cat "$ws/plan/state/claude-code.md")" "the record keeps the flag"
run_setup "$ws" claude-code --no-strict-orchestrator; rc=$?
assert_equals "0" "$rc" "--no-strict-orchestrator exits 0"
[ -f "$ws/plan/.orchestrator-strict" ] && r=yes || r=no
assert_equals "no" "$r" "--no-strict-orchestrator removes strict mode"
assert_contains "strict mode off" "$(cat "$ws/out")" "setup says it turned strict mode off"
assert_contains '"flags": []' "$(cat "$ws/plan/state/claude-code.md")" "the record drops the flag"
run_setup "$ws" claude-code --strict-orchestrator --no-strict-orchestrator; rc=$?
assert_equals "1" "$rc" "both strict flags exit 1"

echo "=== AC-2: the guide has a joining section ==="
guide="$(cat "$ZERO_DIR/getting-started.md")"
assert_contains "## Joining a RAVINTIO repo" "$guide" "joining section exists"
assert_contains "./ravintio-zero/setup.sh claude-code" "$guide" "joining section names the setup command"

echo "=== AC-3: session start reports an unset clone once ==="
ws=$(new_workspace)
run_setup "$ws" claude-code
commit_workspace_pack "$ws"
git -C "$ws" config --unset core.hooksPath
out="$(cd "$ws" && printf '{"cwd":"%s","session_id":"s-382"}' "$ws" | node .claude/hooks/enforcement/auto-trigger-orchestrator.mjs)"
assert_contains "Install check" "$out" "the hook reports the clone"
assert_contains "core.hooksPath" "$out" "the report names the problem"
assert_contains "setup.sh claude-code" "$out" "the report names the setup command"
out2="$(cd "$ws" && printf '{"cwd":"%s","session_id":"s-382"}' "$ws" | node .claude/hooks/enforcement/auto-trigger-orchestrator.mjs)"
assert_equals "" "$out2" "the second prompt of the session stays silent"

print_summary
