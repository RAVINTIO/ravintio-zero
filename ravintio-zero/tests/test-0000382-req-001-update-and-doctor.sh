#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-001: --doctor, --update, and plan/current/.

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

echo "=== AC-1: doctor fails on a copied pack that was never set up ==="
ws=$(new_workspace)
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "1" "$rc" "doctor exits 1 before setup ran"
assert_contains "setup has not run" "$(cat "$ws/out")" "doctor says setup has not run"

echo "=== setup creates plan/current/ and doctor then passes ==="
run_setup "$ws" claude-code; rc=$?
assert_equals "0" "$rc" "setup exits 0"
[ -d "$ws/plan/current" ] && r=yes || r=no
assert_equals "yes" "$r" "setup creates plan/current/"
commit_workspace_pack "$ws"
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "0" "$rc" "doctor exits 0 after setup"
assert_contains "Doctor found no problems" "$(cat "$ws/out")" "doctor reports no problems"

echo "=== AC-2: doctor names a non-executable hook ==="
chmod -x "$ws/ravintio-zero/hooks/pre-push"
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "1" "$rc" "doctor exits 1 on a non-executable hook"
assert_contains "hooks/pre-push is not executable" "$(cat "$ws/out")" "doctor names the hook"
chmod +x "$ws/ravintio-zero/hooks/pre-push"

echo "=== doctor names a stale installed skill and a missing hook wiring ==="
echo "extra" >> "$ws/.claude/skills/ravintio-plan/SKILL.md"
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "1" "$rc" "doctor exits 1 on a skill that differs from the pack"
assert_contains "skill ravintio-plan differs" "$(cat "$ws/out")" "doctor names the skill"

echo "=== AC-3: update copies a newer pack, commits it, and keeps the flags ==="
ws=$(new_workspace)
run_setup "$ws" claude-code --strict-orchestrator
commit_workspace_pack "$ws"
src="$TMP/newer"; mkdir -p "$src"; cp -r "$ZERO_DIR" "$src/ravintio-zero"
echo "new pack file" > "$src/ravintio-zero/NEW-IN-UPDATE.md"
run_setup "$ws" claude-code --update "$src/ravintio-zero"; rc=$?
assert_equals "0" "$rc" "update exits 0"
[ -f "$ws/ravintio-zero/NEW-IN-UPDATE.md" ] && r=yes || r=no
assert_equals "yes" "$r" "update copies the new file"
assert_equals "" "$(git -C "$ws" status --porcelain -- ravintio-zero)" "update committed the pack files"
assert_contains "Update the RAVINTIO Zero pack" "$(git -C "$ws" log --format=%s -1)" "update commit message"
assert_contains "--strict-orchestrator" "$(cat "$ws/out")" "update reruns setup with the recorded flag"
[ -f "$ws/plan/.orchestrator-strict" ] && r=yes || r=no
assert_equals "yes" "$r" "strict mode survives the update"

echo "=== update refuses a dirty pack and a source with no pack ==="
echo dirty >> "$ws/ravintio-zero/README-DIRTY.md"
run_setup "$ws" claude-code --update "$src/ravintio-zero"; rc=$?
assert_equals "1" "$rc" "update exits 1 on uncommitted pack files"
assert_contains "README-DIRTY.md" "$(cat "$ws/out")" "update names the file"
rm "$ws/ravintio-zero/README-DIRTY.md"
run_setup "$ws" claude-code --update "$TMP/empty-nowhere"; rc=$?
assert_equals "1" "$rc" "update exits 1 for a source with no pack"
run_setup "$ws" claude-code --update; rc=$?
assert_equals "1" "$rc" "update exits 1 with no source"

print_summary
