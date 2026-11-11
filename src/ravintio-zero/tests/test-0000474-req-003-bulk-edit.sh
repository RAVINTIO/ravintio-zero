#!/usr/bin/env bash
# Tests for feature 0000474-coordinator-shell-guidance, req-003: the bulk edit script.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$SCRIPT_DIR/../scripts/bulk-edit.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# spec <file> <json>: writes a spec file with node so the test needs no quoting tricks.
spec() { node -e 'require("fs").writeFileSync(process.argv[1], process.argv[2])' "$1" "$2"; }

echo ""
echo "=== req-003 AC-1: literal replacement ==="
R="$WORK/r1"
mkdir -p "$R"
printf 'X and X\nkeep\n' > "$R/one.txt"
printf 'nothing here\n' > "$R/two.txt"
spec "$WORK/s1.json" '{"edits":[{"file":"one.txt","from":"X","to":"$'"'"'x$&"},{"file":"two.txt","from":"zzz","to":"y"}]}'
OUT="$(node "$HELPER" "$WORK/s1.json" --root "$R" 2>&1)"
CODE=$?
assert_exit_zero "$CODE" "AC-1: exits 0"
assert_contains "edited: one.txt (2)" "$OUT" "AC-1: reports two replacements"
assert_contains "unchanged: two.txt" "$OUT" "AC-1: reports the unchanged file"
assert_equals "\$'x\$& and \$'x\$&" "$(head -1 "$R/one.txt")" "AC-1: the replacement text is literal"
assert_equals "2" "$(wc -l < "$R/one.txt" | tr -d ' ')" "AC-1: no duplicated lines"

echo ""
echo "=== req-003 AC-2: unsafe specs write nothing ==="
R="$WORK/r2"
mkdir -p "$R"
printf 'a\n' > "$R/one.txt"
spec "$WORK/s2.json" '{"edits":[{"file":"one.txt","from":"a","to":"b"},{"file":"../x.txt","from":"a","to":"b"}]}'
node "$HELPER" "$WORK/s2.json" --root "$R" >/dev/null 2>&1
assert_equals "1" "$?" "AC-2: a .. path exits 1"
assert_equals "a" "$(cat "$R/one.txt")" "AC-2: the first edit is not written"
spec "$WORK/s3.json" '{"edits":[{"file":"/etc/hosts","from":"a","to":"b"}]}'
node "$HELPER" "$WORK/s3.json" --root "$R" >/dev/null 2>&1
assert_equals "1" "$?" "AC-2: an absolute path exits 1"
spec "$WORK/s4.json" '{"edits":[{"file":"one.txt","from":"","to":"b"}]}'
node "$HELPER" "$WORK/s4.json" --root "$R" >/dev/null 2>&1
assert_equals "1" "$?" "AC-2: an empty from exits 1"
ln -s "$R/one.txt" "$R/link.txt"
spec "$WORK/s5.json" '{"edits":[{"file":"link.txt","from":"a","to":"b"}]}'
node "$HELPER" "$WORK/s5.json" --root "$R" >/dev/null 2>&1
assert_equals "1" "$?" "AC-2: a symlink exits 1"

echo ""
echo "=== req-003 AC-3: dry run ==="
R="$WORK/r3"
mkdir -p "$R"
printf 'a\n' > "$R/one.txt"
spec "$WORK/s6.json" '{"edits":[{"file":"one.txt","from":"a","to":"b"}]}'
OUT="$(node "$HELPER" "$WORK/s6.json" --root "$R" --dry-run 2>&1)"
assert_contains "edited: one.txt (1)" "$OUT" "AC-3: prints the edited line"
assert_equals "a" "$(cat "$R/one.txt")" "AC-3: the file stays"

echo ""
echo "=== req-003: a malformed spec exits 2 ==="
printf 'not json' > "$WORK/bad.json"
node "$HELPER" "$WORK/bad.json" --root "$R" >/dev/null 2>&1
assert_equals "2" "$?" "malformed spec exits 2"
node "$HELPER" "$WORK/missing.json" --root "$R" >/dev/null 2>&1
assert_equals "2" "$?" "missing spec exits 2"

print_summary
