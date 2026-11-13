#!/usr/bin/env bash
# Tests for feature 0000462-tests-without-git-identity, req-002: each script that
# reads the first line of a boot file accepts a file that starts with a UTF-8 BOM.
# Windows PowerShell 5.1 writes that BOM.

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

# Puts the three BOM bytes in front of a file.
add_bom() {
  printf '\xef\xbb\xbf' | cat - "$1" > "$1.bom" && mv "$1.bom" "$1"
}

has_bom() {
  [ "$(head -c 3 "$1" | od -An -tx1 | tr -d ' \n')" = "efbbbf" ] && echo yes || echo no
}

echo ""
echo "=== REQ-002 AC-1: doctor and setup.sh accept a boot file with a BOM ==="
ws=$(new_workspace)
run_setup "$ws" claude-code
commit_workspace_pack "$ws"
add_bom "$ws/CLAUDE.md"
assert_equals "yes" "$(has_bom "$ws/CLAUDE.md")" "REQ-002 fixture: CLAUDE.md starts with a BOM"
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "0" "$rc" "REQ-002 AC-1: doctor exits 0 on a boot file with a BOM"
assert_contains "CLAUDE.md is the pack's" "$(cat "$ws/out")" "REQ-002 AC-1: doctor reports the file as the pack's"
run_setup "$ws" claude-code; rc=$?
assert_equals "0" "$rc" "REQ-002 AC-1: setup exits 0 on a boot file with a BOM"
ORIGINALS="$(ls "$ws/ravintio-overrides/instructions" 2>/dev/null | grep '^original-CLAUDE' || true)"
assert_equals "" "$ORIGINALS" "REQ-002 AC-1: setup copies nothing to ravintio-overrides/instructions/"

echo ""
echo "=== REQ-002 AC-2: setup.ps1 accepts a boot file with a BOM ==="
PS_TEST="$SCRIPT_DIR/test-0000462-req-002-bom-first-line-readers.ps1"
assert_equals "yes" "$([ -f "$PS_TEST" ] && echo yes || echo no)" "REQ-002 AC-2: the PowerShell suite exists"

echo ""
echo "=== REQ-002 AC-3: doctor without its BOM strip rejects the fixture ==="
ws=$(new_workspace)
run_setup "$ws" claude-code
commit_workspace_pack "$ws"
add_bom "$ws/CLAUDE.md"
LIFECYCLE="$ws/ravintio-zero/scripts/install-lifecycle.mjs"
sed -i.bak 's|\.replace(/^\\uFEFF/, "")||' "$LIFECYCLE" && rm -f "$LIFECYCLE.bak"
assert_not_contains "uFEFF" "$(cat "$LIFECYCLE")" "REQ-002 AC-3: the scratch copy has no BOM strip"
run_setup "$ws" claude-code --doctor; rc=$?
assert_equals "1" "$rc" "REQ-002 AC-3: doctor exits 1 without the strip"
assert_contains "not the pack's" "$(cat "$ws/out")" "REQ-002 AC-3: doctor reports the file as not the pack's"

print_summary
