#!/usr/bin/env bash
# Tests for feature 0000319-initiative-history-checks, req-001.
#
# The history script fails on an untitled first-parent commit.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="$SCRIPT_DIR/../scripts/check-initiative-history.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Builds a repo with one base commit on main and an initiative branch.
new_repo() {
  local dir="$TMP/$1"
  mkdir -p "$dir"
  git -C "$dir" init -q -b main
  git -C "$dir" config user.email t@example.com
  git -C "$dir" config user.name T
  git -C "$dir" config commit.gpgsign false
  echo base > "$dir/f"
  git -C "$dir" add f
  git -C "$dir" commit -q -m "base"
  git -C "$dir" checkout -q -b initiative/x
  echo "$dir"
}

add_commit() {
  echo "$2" >> "$1/f"
  git -C "$1" commit -q -am "$2"
}

run_script() {
  OUT="$(node "$SCRIPT" "$@" 2>&1)"
  CODE=$?
}

echo "=== req-001 AC-1: titled squashes pass ==="
R="$(new_repo titled)"
add_commit "$R" "0000319-initiative-history-checks: add script (#12)"
add_commit "$R" "0000320-other-thing2: second change (#13)"
run_script --root "$R" --base main --head HEAD
assert_equals "0" "$CODE" "req-001 AC-1: titled history exits 0"

echo ""
echo "=== req-001 AC-2: a direct commit fails and is named ==="
R="$(new_repo direct)"
add_commit "$R" "0000319-initiative-history-checks: add script (#12)"
add_commit "$R" "fix stuff"
HASH="$(git -C "$R" rev-parse --short HEAD)"
run_script --root "$R" --base main --head HEAD
assert_equals "1" "$CODE" "req-001 AC-2: untitled commit exits 1"
assert_contains "$HASH" "$OUT" "req-001 AC-2: prints the short hash"
assert_contains "fix stuff" "$OUT" "req-001 AC-2: prints the subject"
case "$OUT" in
  *"add script"*) assert_equals "absent" "present" "req-001 AC-2: titled commit not listed" ;;
  *) assert_equals "absent" "absent" "req-001 AC-2: titled commit not listed" ;;
esac

echo ""
echo "=== req-001 AC-2: near-miss titles fail ==="
for subj in "0000319-Bad_Slug: x (#1)" "000319-short-id: x (#1)" "0000319-no-number: x" "0000319-slug:  (#1)"; do
  R="$(new_repo "near$RANDOM")"
  add_commit "$R" "$subj"
  run_script --root "$R" --base main --head HEAD
  assert_equals "1" "$CODE" "req-001 AC-2: rejects '$subj'"
done

echo ""
echo "=== req-001 AC-3: empty branch exits 0 with a note ==="
R="$(new_repo empty)"
run_script --root "$R" --base main --head HEAD
assert_equals "0" "$CODE" "req-001 AC-3: empty branch exits 0"
assert_contains "no commits" "$OUT" "req-001 AC-3: empty branch prints a note"

echo ""
echo "=== req-001 AC-3: missing base ref exits 1 ==="
R="$(new_repo missing)"
run_script --root "$R" --base origin/main --head HEAD
assert_equals "1" "$CODE" "req-001 AC-3: missing base exits 1"
assert_contains "origin/main" "$OUT" "req-001 AC-3: message names the ref"

echo ""
echo "=== req-001: default base is origin/main ==="
R="$(new_repo defaults)"
run_script --root "$R"
assert_equals "1" "$CODE" "req-001: default base origin/main is missing here"
assert_contains "origin/main" "$OUT" "req-001: default message names origin/main"

print_summary
