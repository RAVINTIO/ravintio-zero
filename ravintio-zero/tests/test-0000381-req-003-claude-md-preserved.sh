#!/usr/bin/env bash
# Tests for feature 0000381-setup-safety, req-003: a first install moves a
# developer's own CLAUDE.md content to ravintio-overrides/instructions/.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

WS=$(mktemp -d "$TMP/ws_XXXXXX")
cp -r "$ZERO_DIR" "$WS/ravintio-zero"
git init "$WS" >/dev/null 2>&1
commit_workspace_pack "$WS"
printf '# Team rules\n\nAlways squash. Never rebase shared branches.\n' >"$WS/CLAUDE.md"
run_setup() {
  commit_workspace_pack "$WS"
  (cd "$WS" && GIT_CEILING_DIRECTORIES="$(dirname "$WS")" bash ravintio-zero/setup.sh claude-code >"$WS/setup.out" 2>"$WS/setup.err")
}
run_setup

DEST="$WS/ravintio-overrides/instructions/original-CLAUDE.md"
echo ""
echo "=== req-003 AC-1: the content moves to the overrides ==="
[ -f "$DEST" ] && r=yes || r=no
assert_equals yes "$r" "AC-1: original-CLAUDE.md exists in ravintio-overrides/instructions/"
assert_contains "Always squash" "$(cat "$DEST" 2>/dev/null)" "AC-1: it holds the developer content"
assert_contains "ravintio-overrides/instructions/original-CLAUDE.md" "$(cat "$WS/setup.out")" "AC-1: setup names the file"

echo ""
echo "=== req-003 AC-2: the new CLAUDE.md includes the content ==="
assert_contains "Always squash" "$(cat "$WS/CLAUDE.md")" "AC-2: CLAUDE.md carries the moved content"
assert_contains "RAVINTIO Zero - Mandatory Pipeline Rules" "$(cat "$WS/CLAUDE.md")" "AC-2: CLAUDE.md carries the pack rules"

echo ""
echo "=== req-003 AC-3: a re-run moves nothing ==="
before="$(ls "$WS/ravintio-overrides/instructions" | wc -l | tr -d ' ')"
hash_before="$(cksum <"$DEST")"
run_setup
after="$(ls "$WS/ravintio-overrides/instructions" | wc -l | tr -d ' ')"
assert_equals "$before" "$after" "AC-3: no new file appears"
assert_equals "$hash_before" "$(cksum <"$DEST")" "AC-3: the moved file is unchanged"
assert_not_contains "original-CLAUDE.md" "$(cat "$WS/setup.out")" "AC-3: setup does not mention a move"

echo ""
echo "=== req-003: an existing destination is never overwritten ==="
WS2=$(mktemp -d "$TMP/ws_XXXXXX")
cp -r "$ZERO_DIR" "$WS2/ravintio-zero"
git init "$WS2" >/dev/null 2>&1
commit_workspace_pack "$WS2"
mkdir -p "$WS2/ravintio-overrides/instructions"
echo "earlier" >"$WS2/ravintio-overrides/instructions/original-CLAUDE.md"
echo "Second content" >"$WS2/CLAUDE.md"
commit_workspace_pack "$WS2"
(cd "$WS2" && GIT_CEILING_DIRECTORIES="$(dirname "$WS2")" bash ravintio-zero/setup.sh claude-code >"$WS2/setup.out" 2>&1)
assert_equals "earlier" "$(cat "$WS2/ravintio-overrides/instructions/original-CLAUDE.md")" "the earlier file is unchanged"
assert_contains "Second content" "$(cat "$WS2/ravintio-overrides/instructions/original-CLAUDE-2.md" 2>/dev/null)" "the content goes to a numbered file"

print_summary
