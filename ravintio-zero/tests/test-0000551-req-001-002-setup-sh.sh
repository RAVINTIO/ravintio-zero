#!/usr/bin/env bash
# Tests for feature 0000551-refuse-symlink-style-outputs, req-001 and req-002:
# setup.sh refuses a link at the style file path, its folder, and AGENTS.md
# for the writing block.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STYLE_FILE=".claude/output-styles/ravintio-writing.md"
STYLE_LINE="  ! Refused: $STYLE_FILE is a link, writing style not installed"
AGENTS_LINE="  ! Refused: AGENTS.md is a link, writing section not installed"

make_workspace() {
  local dir
  dir=$(mktemp -d -t ravintio_0000551_setup_test_XXXXXX)
  cp -r "$ZERO_DIR" "$dir/ravintio-zero"
  commit_workspace_pack "$dir"
  echo "$dir"
}

echo ""
echo "=== req-001 AC-1: a link at the style file ==="
WS=$(make_workspace); cd "$WS"
mkdir -p .claude/output-styles
echo "victim content" > victim.txt
BEFORE="$(cksum < victim.txt)"
ln -s ../../victim.txt "$STYLE_FILE"
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-001 AC-1: setup exits 0"
assert_equals "$BEFORE" "$(cksum < victim.txt)" "req-001 AC-1: the target keeps its bytes"
assert_contains "$STYLE_LINE" "$OUT" "req-001 AC-1: the fixed line is printed"
[ -L "$STYLE_FILE" ] && R=link || R=gone
assert_equals "link" "$R" "req-001 AC-1: the link stays"
node -e 'const s=JSON.parse(require("fs").readFileSync(".claude/settings.json","utf8")); process.stdout.write(s.outputStyle===undefined?"absent":"set")' > outstyle.txt
assert_equals "absent" "$(cat outstyle.txt)" "req-001 AC-1: outputStyle stays unset"
rm -f "$STYLE_FILE"
ln -s ../../missing-target.txt "$STYLE_FILE"
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-001 AC-1: a broken link exits 0"
[ -e missing-target.txt ] && R=created || R=absent
assert_equals "absent" "$R" "req-001 AC-1: a broken link target is not created"
assert_contains "$STYLE_LINE" "$OUT" "req-001 AC-1: a broken link prints the fixed line"
cd /; rm -rf "$WS"

echo ""
echo "=== req-001 AC-2: a link at the style folder ==="
WS=$(make_workspace); cd "$WS"
mkdir -p other-folder .claude
ln -s ../other-folder .claude/output-styles
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-001 AC-2: setup exits 0"
assert_equals "0" "$(find other-folder -type f | wc -l | tr -d ' ')" "req-001 AC-2: the other folder gains no file"
assert_contains "$STYLE_LINE" "$OUT" "req-001 AC-2: the fixed line is printed"
cd /; rm -rf "$WS"

echo ""
echo "=== req-001 AC-3: no link, the install is unchanged ==="
WS=$(make_workspace); cd "$WS"
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-001 AC-3: setup exits 0"
[ -f "$STYLE_FILE" ] && [ ! -L "$STYLE_FILE" ] && R=file || R=missing
assert_equals "file" "$R" "req-001 AC-3: the style file is a plain file"
assert_not_contains "Refused" "$OUT" "req-001 AC-3: no refusal line"
cd /; rm -rf "$WS"

echo ""
echo "=== req-002 AC-1: a link at AGENTS.md ==="
WS=$(make_workspace); cd "$WS"
echo "victim content" > victim.txt
ln -s victim.txt AGENTS.md
OUT="$(bash ravintio-zero/setup.sh codex 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-002 AC-1: setup exits 0"
assert_equals "0" "$(grep -c 'ravintio-writing:start' victim.txt)" "req-002 AC-1: the target holds no writing block"
assert_contains "$AGENTS_LINE" "$OUT" "req-002 AC-1: the fixed line is printed"
cd /; rm -rf "$WS"

echo ""
echo "=== req-002 AC-2: a plain AGENTS.md keeps one block ==="
WS=$(make_workspace); cd "$WS"
OUT="$(bash ravintio-zero/setup.sh codex 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-002 AC-2: setup exits 0"
assert_equals "1" "$(grep -c 'ravintio-writing:start' AGENTS.md)" "req-002 AC-2: one writing block"
assert_not_contains "Refused" "$OUT" "req-002 AC-2: no refusal line"
cd /; rm -rf "$WS"

print_summary
