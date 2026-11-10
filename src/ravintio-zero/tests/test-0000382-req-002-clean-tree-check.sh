#!/usr/bin/env bash
# Tests for feature 0000382-install-lifecycle, req-002: setup copies only committed pack and override files.

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

echo "=== AC-1: a modified pack file blocks setup ==="
ws=$(new_workspace)
echo "edit" >> "$ws/ravintio-zero/getting-started.md"
run_setup "$ws" claude-code; rc=$?
assert_equals "1" "$rc" "setup exits 1 on a modified pack file"
assert_contains "ravintio-zero/getting-started.md" "$(cat "$ws/out")" "setup names the file"
[ -e "$ws/.claude/skills" ] && r=yes || r=no
assert_equals "no" "$r" "setup copied nothing"

echo "=== AC-2: an untracked override blocks, an ignored file does not ==="
ws=$(new_workspace)
mkdir -p "$ws/ravintio-overrides/instructions"
echo "rule" > "$ws/ravintio-overrides/instructions/custom-9.md"
run_setup "$ws" claude-code; rc=$?
assert_equals "1" "$rc" "setup exits 1 on an untracked override"
assert_contains "ravintio-overrides/instructions/custom-9.md" "$(cat "$ws/out")" "setup names the override"
commit_workspace_pack "$ws"
printf 'ignored-cache.txt\n' > "$ws/.gitignore"
echo "cache" > "$ws/ravintio-zero/ignored-cache.txt"
run_setup "$ws" claude-code; rc=$?
assert_equals "0" "$rc" "an ignored file does not block setup"

echo "=== AC-3: setup outside a git repository fails ==="
ws=$(mktemp -d "$TMP/nogit_XXXXXX")
cp -r "$ZERO_DIR" "$ws/ravintio-zero"
run_setup "$ws" claude-code; rc=$?
assert_equals "1" "$rc" "setup exits 1 outside a git repository"
assert_contains "git repository" "$(cat "$ws/out")" "the message names git"

echo "=== no bypass flag ==="
assert_not_contains "bypass" "$(bash "$ZERO_DIR/setup.sh" --help)" "help offers no bypass"
ws=$(new_workspace)
echo "edit" >> "$ws/ravintio-zero/getting-started.md"
run_setup "$ws" claude-code --force; rc=$?
assert_equals "1" "$rc" "an unknown flag does not bypass the check"

print_summary
