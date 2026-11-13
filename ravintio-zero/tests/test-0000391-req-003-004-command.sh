#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, REQ-003 and REQ-004: the archetype command.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

CMD="$TMP/ravintio-zero/scripts/archetype.mjs"
arch() { node "$CMD" --root "$TMP" "$@" 2>&1; }

tree_hash() {
  (cd "$TMP/ravintio-overrides" 2>/dev/null && find . \( -type f -o -type l \) | LC_ALL=C sort | while IFS= read -r f; do
    [ -n "$f" ] || continue
    printf '%s %s\n' "$f" "$(shasum "$f" | cut -d' ' -f1)"
  done) || true
}

reset_repo() {
  rm -rf "$TMP"/* "$TMP"/.[!.]* 2>/dev/null
  mkdir -p "$TMP/ravintio-zero"
  cp -R "$ZERO_DIR/scripts" "$TMP/ravintio-zero/scripts"
  cp -R "$ZERO_DIR/archetypes" "$TMP/ravintio-zero/archetypes"
  mkdir -p "$TMP/ravintio-zero/standards"
  printf 'pack writing\n' > "$TMP/ravintio-zero/standards/writing-standards.md"
}

make_arch() { # kind name slot threshold-json file
  local d="$TMP/ravintio-zero/archetypes/$1/$2"
  mkdir -p "$d/files/standards"
  printf '{"name":"%s","kind":"%s","summary":"temp %s","slots":["%s"],"thresholds":%s,"gates":[]}\n' "$2" "$1" "$2" "$3" "$4" > "$d/archetype.json"
  printf 'content of %s\n' "$2" > "$d/files/standards/$5"
}

reset_repo

echo ""
echo "=== req-003: list ==="
OUT1="$(arch list)"; RC=$?
OUT2="$(arch list)"
assert_equals "0" "$RC" "req-003 list exits 0"
assert_contains "alternative/us-writing" "$OUT1" "req-003 list names alternative/us-writing"
assert_contains "constraint/strict-testing" "$OUT1" "req-003 list names constraint/strict-testing"
assert_contains "Swaps the British English spelling rule" "$OUT1" "req-003 list prints the summary"
assert_equals "4" "$(printf '%s\n' "$OUT1" | grep -c '^[a-z]*/')" "req-003 list prints four archetypes"
assert_equals "$OUT1" "$OUT2" "req-003 list is deterministic"
assert_equals "$(printf '%s\n' "$OUT1" | LC_ALL=C sort)" "$OUT1" "req-003 list is sorted"

echo ""
echo "=== req-003 AC-1: use copies, reports, records ==="
OUT="$(arch use alternative/us-writing)"; RC=$?
assert_equals "0" "$RC" "req-003 use exits 0"
assert_equals "1" "$([ -f "$TMP/ravintio-overrides/standards/writing-standards.md" ] && echo 1)" "req-003 use copies the file under ravintio-overrides"
assert_contains "replaces: ravintio-zero/standards/writing-standards.md" "$OUT" "req-003 use prints the replaced pack file"
assert_equals "1" "$(printf '%s\n' "$OUT" | grep -c '^replaces:')" "req-003 use prints one replaces line per file"
assert_contains "archetype use: alternative/us-writing installed" "$OUT" "req-003 use prints the installed line"
assert_equals '{"installed":["alternative/us-writing"]}' "$(tr -d ' \n' < "$TMP/ravintio-overrides/archetypes.json")" "req-003 use creates archetypes.json with the pick"
assert_equals "1" "$([ -f "$TMP/ravintio-overrides/archetypes/alternative/us-writing/archetype.json" ] && echo 1)" "req-003 use copies the manifest for the gate script"

echo ""
echo "=== req-003 AC-2: rerun changes nothing ==="
BEFORE="$(tree_hash)"
OUT="$(arch use alternative/us-writing)"; RC=$?
assert_equals "0" "$RC" "req-003 rerun exits 0"
assert_equals "$BEFORE" "$(tree_hash)" "req-003 rerun changes no file"
assert_contains "archetype use: nothing changed" "$OUT" "req-003 rerun prints that nothing changed"

echo ""
echo "=== req-004 AC-1: slot clash ==="
reset_repo
make_arch constraint one stack-list '{}' one.md
make_arch constraint two stack-list '{}' two.md
arch use constraint/one >/dev/null
BEFORE="$(tree_hash)"
OUT="$(arch use constraint/two)"; RC=$?
assert_equals "1" "$RC" "req-004 a slot clash exits 1"
assert_contains "clash:" "$OUT" "req-004 a slot clash prints a clash line"
assert_contains "constraint/one" "$OUT" "req-004 the clash names the installed archetype"
assert_contains "constraint/two" "$OUT" "req-004 the clash names the picked archetype"
assert_equals "$BEFORE" "$(tree_hash)" "req-004 a slot clash leaves ravintio-overrides unchanged"

echo ""
echo "=== req-004 AC-2: file clash ==="
reset_repo
make_arch constraint one slot-a '{}' shared.md
make_arch constraint two slot-b '{}' shared.md
arch use constraint/one >/dev/null
BEFORE="$(tree_hash)"
OUT="$(arch use constraint/two)"; RC=$?
assert_equals "1" "$RC" "req-004 a file clash exits 1"
assert_contains "clash:" "$OUT" "req-004 a file clash prints a clash line"
assert_equals "$BEFORE" "$(tree_hash)" "req-004 a file clash leaves ravintio-overrides unchanged"

echo ""
echo "=== req-004: developer override clash ==="
reset_repo
make_arch constraint one slot-a '{}' mine.md
mkdir -p "$TMP/ravintio-overrides/standards"
printf 'my own\n' > "$TMP/ravintio-overrides/standards/mine.md"
BEFORE="$(tree_hash)"
OUT="$(arch use constraint/one)"; RC=$?
assert_equals "1" "$RC" "req-004 an unrecorded differing override exits 1"
assert_contains "clash:" "$OUT" "req-004 an unrecorded differing override prints a clash line"
assert_equals "$BEFORE" "$(tree_hash)" "req-004 the developer override stays unchanged"

echo ""
echo "=== req-004 AC-3: thresholds ==="
reset_repo
make_arch constraint high slot-a '{"mutation-score":80}' high.md
make_arch constraint low slot-b '{"mutation-score":60}' low.md
make_arch constraint same slot-c '{"mutation-score":80}' same.md
make_arch constraint above slot-d '{"mutation-score":90}' above.md
arch use constraint/high >/dev/null
BEFORE="$(tree_hash)"
OUT="$(arch use constraint/low)"; RC=$?
assert_equals "1" "$RC" "req-004 a lower threshold exits 1"
assert_contains "threshold:" "$OUT" "req-004 a lower threshold prints a threshold line"
assert_equals "$BEFORE" "$(tree_hash)" "req-004 a lower threshold copies nothing"
OUT="$(arch use constraint/same)"; RC=$?
assert_equals "0" "$RC" "req-004 an equal threshold passes"
OUT="$(arch use constraint/above)"; RC=$?
assert_equals "0" "$RC" "req-004 a higher threshold passes"

echo ""
echo "=== req-004: unsafe input ==="
reset_repo
OUT="$(arch use alternative/nope)"; RC=$?
assert_equals "1" "$RC" "req-004 an unknown name exits 1"
OUT="$(arch use alternative/../../etc)"; RC=$?
assert_equals "1" "$RC" "req-004 a name with .. exits 1"
OUT="$(arch use /etc/passwd)"; RC=$?
assert_equals "1" "$RC" "req-004 an absolute path exits 1"
mkdir -p "$TMP/ravintio-overrides/standards"
ln -s "$TMP/elsewhere" "$TMP/ravintio-overrides/standards/writing-standards.md"
OUT="$(arch use alternative/us-writing)"; RC=$?
assert_equals "1" "$RC" "req-004 a symlink at a destination exits 1"
assert_equals "1" "$([ ! -e "$TMP/elsewhere" ] && echo 1)" "req-004 nothing is written through the symlink"

print_summary
