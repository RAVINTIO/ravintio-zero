#!/usr/bin/env bash
# Tests for feature 0000389-writing-standard, generator behind req-003 and
# req-004: writing-style.mjs prints each tool's output from the standard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GEN="$ZERO_DIR/scripts/writing-style.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "=== generator: claude-code ==="
OUT="$(node "$GEN" claude-code)"
assert_contains "name: ravintio-writing" "$OUT" "claude-code output names the style"
assert_contains "keep-coding-instructions: true" "$OUT" "claude-code output keeps coding instructions"
assert_contains "Lead with the answer or result" "$OUT" "claude-code output holds the style-rules region"
assert_not_contains "BEGIN style-rules" "$OUT" "claude-code output holds no region markers"
assert_equals "---" "$(printf '%s\n' "$OUT" | head -1)" "claude-code output opens with frontmatter"

echo ""
echo "=== generator: codex ==="
OUT="$(node "$GEN" codex)"
assert_equals "<!-- ravintio-writing:start -->" "$(printf '%s\n' "$OUT" | head -1)" "codex output opens with the start marker"
assert_contains "<!-- ravintio-writing:end -->" "$OUT" "codex output ends with the end marker"
assert_contains "writing-standards.md" "$OUT" "codex output points to the standard"
assert_contains "Keep every sentence under 25 words" "$OUT" "codex output holds the summary region"

echo ""
echo "=== generator: symlinked path ==="
ln -s "$ZERO_DIR/scripts" "$TMP/linked-scripts"
OUT="$(node "$TMP/linked-scripts/writing-style.mjs" codex)"
assert_contains "ravintio-writing:start" "$OUT" "output is not empty when run through a symlinked path"

echo ""
echo "=== generator: failures ==="
node "$GEN" vim >/dev/null 2>"$TMP/err"; assert_equals "1" "$?" "unknown tool exits 1"
echo "no regions" > "$TMP/std.md"
node "$GEN" codex "$TMP/std.md" >/dev/null 2>"$TMP/err"; assert_equals "1" "$?" "missing region exits 1"
assert_contains "region summary not found" "$(cat "$TMP/err")" "missing region names the region"

print_summary
