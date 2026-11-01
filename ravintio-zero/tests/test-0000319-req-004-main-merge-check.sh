#!/usr/bin/env bash
# Tests for feature 0000319-initiative-history-checks, req-004 AC-1 and AC-2.
#
# check-main-merge.mjs flags a one-parent initiative PR commit on main.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$SCRIPT_DIR/../scripts/check-main-merge.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Make a fixture repo with one base commit. Prints the repo path.
new_repo() {
  local d="$TMP/$1"
  mkdir -p "$d"
  git -C "$d" init -q -b main
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  git -C "$d" config commit.gpgsign false
  echo base > "$d/f"
  git -C "$d" add f
  git -C "$d" commit -q -m "base"
  echo "$d"
}

run_check() {
  node "$CHECK" --root "$1" >"$TMP/out" 2>&1
  echo $?
}

echo "=== req-004 AC-1: a squash fails ==="
R1="$(new_repo squash)"
echo a > "$R1/f"
git -C "$R1" commit -q -am "0000312-guards-history-and-test-noise: deliver (#80)"
assert_equals "1" "$(run_check "$R1")" "req-004 AC-1: one-parent titled commit exits 1"
assert_contains "squash" "$(cat "$TMP/out")" "req-004 AC-1: message names the squash"

R2="$(new_repo body)"
echo a > "$R2/f"
git -C "$R2" commit -q -am "Deliver the initiative" -m "- 0000312-guards-history-and-test-noise: step one (#79)"
assert_equals "1" "$(run_check "$R2")" "req-004 AC-1: titled body bullet on one parent exits 1"

echo ""
echo "=== req-004 AC-2: a merge commit passes ==="
R3="$(new_repo merge)"
git -C "$R3" checkout -q -b initiative/0000312-x
echo a > "$R3/g"
git -C "$R3" add g
git -C "$R3" commit -q -m "work"
git -C "$R3" checkout -q main
echo b > "$R3/h"
git -C "$R3" add h
git -C "$R3" commit -q -m "other"
git -C "$R3" merge -q --no-ff initiative/0000312-x -m "Merge pull request #80 from owner/initiative/0000312-x"
assert_equals "0" "$(run_check "$R3")" "req-004 AC-2: two-parent commit exits 0"

echo ""
echo "=== req-004: an ordinary commit passes ==="
R4="$(new_repo ordinary)"
echo a > "$R4/f"
git -C "$R4" commit -q -am "fix a typo (#12)"
assert_equals "0" "$(run_check "$R4")" "req-004: ordinary commit exits 0"

echo ""
echo "=== req-004: --ref selects the commit ==="
git -C "$R1" tag squashed
echo c > "$R1/f"
git -C "$R1" commit -q -am "later work"
assert_equals "0" "$(run_check "$R1")" "req-004: HEAD ordinary commit exits 0"
node "$CHECK" --root "$R1" --ref squashed >/dev/null 2>&1
assert_equals "1" "$?" "req-004: --ref squashed exits 1"

print_summary
