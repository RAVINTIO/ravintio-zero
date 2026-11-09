#!/usr/bin/env bash
# Tests for feature 0000389-writing-standard, req-003 to req-005: setup.sh
# installs the writing standard per tool and honours --no-writing-style.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STYLE="ravintio-zero/scripts/writing-style.mjs"
STYLE_FILE=".claude/output-styles/ravintio-writing.md"

make_workspace() {
  local dir
  dir=$(mktemp -d -t ravintio_0000389_setup_test_XXXXXX)
  cp -r "$ZERO_DIR" "$dir/ravintio-zero"
  commit_workspace_pack "$dir"
  echo "$dir"
}

# The flags marker holds a writtenAt timestamp, so the sum skips it.
tree_sum() {
  find "$@" -type f ! -name .ravintio-setup-flags 2>/dev/null | LC_ALL=C sort | while IFS= read -r f; do cksum < "$f"; done | cksum
}

setting() {
  node -e 'const s=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); process.stdout.write(s.outputStyle===undefined?"(absent)":String(s.outputStyle))' "$1"
}

block_count() {
  grep -c '<!-- ravintio-writing:start -->' "$1"
}

echo ""
echo "=== req-003 AC-1: claude-code install, no settings.json ==="
WS=$(make_workspace); cd "$WS"
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"; EXIT=$?
assert_equals "0" "$EXIT" "req-003 AC-1: setup exits 0"
[ -f "$STYLE_FILE" ] && R=yes || R=no
assert_equals "yes" "$R" "req-003 AC-1: the style file exists"
assert_equals "ravintio-writing" "$(setting .claude/settings.json)" "req-003 AC-1: outputStyle is ravintio-writing"
assert_contains "+ $STYLE_FILE (created)" "$OUT" "req-003 AC-1: the created line is printed"
assert_contains "outputStyle set to ravintio-writing" "$OUT" "req-003 AC-1: the set line is printed"

echo ""
echo "=== req-003 AC-3: no drift, no churn ==="
node "$STYLE" claude-code > "$WS.expected"
assert_equals "$(cat "$WS.expected")" "$(cat "$STYLE_FILE")" "req-003 AC-3: the file matches a fresh generation"
cmp -s "$WS.expected" "$STYLE_FILE" && R=same || R=differ
assert_equals "same" "$R" "req-003 AC-3: the file is byte-identical to a fresh generation"
rm -f "$WS.expected"
BEFORE="$(tree_sum .claude)"
OUT2="$(bash ravintio-zero/setup.sh claude-code 2>&1)"
assert_equals "$BEFORE" "$(tree_sum .claude)" "req-003 AC-3: a second run changes no byte of .claude"
assert_contains "- $STYLE_FILE (unchanged)" "$OUT2" "req-003 AC-3: the unchanged line is printed"
assert_contains "outputStyle already ravintio-writing" "$OUT2" "req-003 AC-3: the already-set line is printed"
cd /; rm -rf "$WS"

echo ""
echo "=== req-003 AC-2: existing outputStyle stays ==="
WS=$(make_workspace); cd "$WS"
mkdir -p .claude
echo '{"outputStyle":"Concise"}' > .claude/settings.json
OUT="$(bash ravintio-zero/setup.sh claude-code 2>&1)"
assert_equals "Concise" "$(setting .claude/settings.json)" "req-003 AC-2: outputStyle is still Concise"
assert_contains "outputStyle already set to Concise, left as is" "$OUT" "req-003 AC-2: setup says it left the value"
cd /; rm -rf "$WS"

echo ""
echo "=== req-004: codex AGENTS.md holds one writing block ==="
WS=$(make_workspace); cd "$WS"
mkdir -p ravintio-overrides/instructions
echo "Local rule for the test." > ravintio-overrides/instructions/custom-001-test.md
commit_workspace_pack "$WS"
OUT="$(bash ravintio-zero/setup.sh codex 2>&1)"
assert_equals "1" "$(block_count AGENTS.md)" "req-004 AC-1: one writing block after the first run"
assert_contains "+ AGENTS.md (writing section added)" "$OUT" "req-004 AC-1: the added line is printed"
node "$STYLE" codex > "$WS.expected"
grep -qF -f "$WS.expected" AGENTS.md && R=yes || R=no
assert_equals "yes" "$R" "req-004 AC-1: AGENTS.md holds the fresh generation"
rm -f "$WS.expected"
assert_contains "Local rule for the test." "$(cat AGENTS.md)" "req-004: the override instructions stay"
SUM1="$(cksum < AGENTS.md)"
OUT2="$(bash ravintio-zero/setup.sh codex 2>&1)"
assert_equals "1" "$(block_count AGENTS.md)" "req-004 AC-2: one writing block after a rerun"
assert_equals "$SUM1" "$(cksum < AGENTS.md)" "req-004 AC-2: AGENTS.md is byte-identical after a rerun"
assert_contains "- AGENTS.md (writing section unchanged)" "$OUT2" "req-004 AC-2: the unchanged line is printed"
[ -e "$STYLE_FILE" ] && R=present || R=absent
assert_equals "absent" "$R" "req-004: codex writes no output style file"
cd /; rm -rf "$WS"

echo ""
echo "=== req-004: codex without overrides is also stable ==="
WS=$(make_workspace); cd "$WS"
bash ravintio-zero/setup.sh codex >/dev/null 2>&1
SUM1="$(cksum < AGENTS.md)"
bash ravintio-zero/setup.sh codex >/dev/null 2>&1
assert_equals "$SUM1" "$(cksum < AGENTS.md)" "req-004 AC-2: no-override rerun is byte-identical"
assert_equals "1" "$(block_count AGENTS.md)" "req-004 AC-2: one block with no overrides"
cd /; rm -rf "$WS"

echo ""
echo "=== req-005 AC-1: --no-writing-style ==="
for TOOL in claude-code codex; do
  WS=$(make_workspace); cd "$WS"
  OUT="$(bash ravintio-zero/setup.sh "$TOOL" --no-writing-style 2>&1)"; EXIT=$?
  assert_equals "0" "$EXIT" "req-005 AC-1: $TOOL exits 0"
  [ -e "$STYLE_FILE" ] && R=present || R=absent
  assert_equals "absent" "$R" "req-005 AC-1: $TOOL writes no style file"
  if [ "$TOOL" = claude-code ]; then
    assert_equals "(absent)" "$(setting .claude/settings.json)" "req-005 AC-1: no outputStyle key"
  else
    assert_equals "0" "$(block_count AGENTS.md)" "req-005 AC-1: no writing block in AGENTS.md"
  fi
  assert_contains "writing style skipped (--no-writing-style)" "$OUT" "req-005 AC-1: $TOOL prints the skip line"
  assert_contains "--no-writing-style" "$(cat plan/state/$TOOL.md)" "req-005 AC-1: $TOOL setup record lists the flag"
  assert_contains "--no-writing-style" "$(cat "$(dirname "$(ls -d .claude/skills .agents/skills 2>/dev/null | head -1)")/.ravintio-setup-flags")" "req-005 AC-1: $TOOL marker lists the flag"
  cd /; rm -rf "$WS"
done

echo ""
echo "=== req-005: the flag works in any position ==="
WS=$(make_workspace); cd "$WS"
bash ravintio-zero/setup.sh --no-writing-style claude-code >/dev/null 2>&1
[ -e "$STYLE_FILE" ] && R=present || R=absent
assert_equals "absent" "$R" "req-005: flag before the tool name is accepted"
bash ravintio-zero/setup.sh claude-code --strict-orchestrator --no-writing-style >/dev/null 2>&1
assert_equals "0" "$?" "req-005: flag after another flag is accepted"
[ -e "$STYLE_FILE" ] && R=present || R=absent
assert_equals "absent" "$R" "req-005: flag after another flag skips the install"
cd /; rm -rf "$WS"

print_summary
