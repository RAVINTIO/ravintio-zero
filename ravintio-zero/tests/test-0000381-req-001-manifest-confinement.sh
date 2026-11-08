#!/usr/bin/env bash
# Tests for feature 0000381-setup-safety, req-001: setup removes only the folders
# its manifest lists inside the skills directory, and writes repo-relative paths.

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
  printf '%s\n' "$ws"
}

run_setup() {
  (cd "$1" && GIT_CEILING_DIRECTORIES="$(dirname "$1")" bash ravintio-zero/setup.sh claude-code \
    >"$1/setup.out" 2>"$1/setup.err")
}

echo ""
echo "=== req-001 AC-2: setup writes a repo-relative manifest ==="

WS="$(new_workspace)"
run_setup "$WS"
MANIFEST="$WS/.claude/skills/.ravintio-manifest"
first="$(head -1 "$MANIFEST")"
assert_contains ".claude/skills/ravintio-" "$first" "AC-2: first manifest line starts with the skills directory"
case "$first" in
  /*) r=absolute ;;
  *) r=relative ;;
esac
assert_equals relative "$r" "AC-2: manifest lines are not absolute"
bad="$(grep -c '^/' "$MANIFEST" || true)"
assert_equals 0 "$bad" "AC-2: no manifest line is absolute"

echo ""
echo "=== req-001 AC-1: lines outside the skills directory are skipped ==="

OUT="$TMP/outside"
mkdir -p "$OUT/abs" "$OUT/dots" "$OUT/linktarget"
echo keep >"$OUT/abs/keep.txt"
echo keep >"$OUT/dots/keep.txt"
echo keep >"$OUT/linktarget/keep.txt"
ln -s "$OUT/linktarget" "$WS/.claude/skills/planted-link"
{
  cat "$MANIFEST"
  printf '%s\n' "$OUT/abs"
  printf '%s\n' ".claude/skills/../../../outside/dots"
  printf '%s\n' ".claude/skills/planted-link"
} >"$MANIFEST.new"
mv "$MANIFEST.new" "$MANIFEST"
# A relative form of the dots target that really leaves the tree.
rel="$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$OUT/dots" "$WS")"
printf '%s\n' "$rel" >>"$MANIFEST"
run_setup "$WS"
for d in abs dots linktarget; do
  [ -f "$OUT/$d/keep.txt" ] && r=survived || r=deleted
  assert_equals survived "$r" "AC-1: $d target survives"
done
assert_contains "outside the skills directory" "$(cat "$WS/setup.out")" "AC-1: setup warns about a skipped line"

echo ""
echo "=== req-001: a listed folder inside the skills directory is still removed ==="

mkdir -p "$WS/.claude/skills/old-pack-skill"
echo x >"$WS/.claude/skills/old-pack-skill/SKILL.md"
printf '%s\n' ".claude/skills/old-pack-skill" >>"$MANIFEST"
printf '%s\n' "$WS/.claude/skills/old-pack-skill-legacy" >>"$MANIFEST"
mkdir -p "$WS/.claude/skills/old-pack-skill-legacy"
run_setup "$WS"
[ -d "$WS/.claude/skills/old-pack-skill" ] && r=present || r=gone
assert_equals gone "$r" "relative line inside the skills directory is removed"
[ -d "$WS/.claude/skills/old-pack-skill-legacy" ] && r=present || r=gone
assert_equals gone "$r" "legacy absolute line inside the skills directory is removed"

echo ""
echo "=== req-001 AC-3: the runner compares the skills listing ==="

assert_contains "Skills changed during the run" "$(cat "$ZERO_DIR/tests/run-tests.sh")" "AC-3: run-tests.sh checks the skills listing"
assert_contains "Skills changed during the run" "$(cat "$ZERO_DIR/tests/run-tests.ps1")" "AC-3: run-tests.ps1 checks the skills listing"

print_summary
