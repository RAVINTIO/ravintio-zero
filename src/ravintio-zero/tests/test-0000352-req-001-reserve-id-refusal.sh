#!/usr/bin/env bash
# 0000352 req-001: reserve-id.mjs --commit refuses on initiative/* and commits nothing.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

RESERVE="$ZERO_DIR/scripts/reserve-id.mjs"
TMP="$(mktemp -d -t ravintio_0000352_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

# make_repo <name> <branch>: a scratch repo with one commit that holds the counter file.
make_repo() {
  local d="$TMP/$1"
  mkdir -p "$d/plan/backlog"
  git -C "$d" init -q -b main
  git -C "$d" config user.email t@example.com
  git -C "$d" config user.name t
  printf '0000100\n' > "$d/plan/backlog/.next-id"
  git -C "$d" add -A
  git -C "$d" commit -q -m "seed"
  git -C "$d" checkout -q -b "$2"
}

echo "=== req-001 AC-1: refusal on initiative/* ==="
make_repo a initiative/0000999-demo
BEFORE=$(git -C "$TMP/a" rev-parse HEAD)
OUT=$(cd "$TMP/a" && node "$RESERVE" --commit 2>&1); RC=$?
assert_equals "1" "$RC" "AC-1: exits 1"
assert_equals "0000100" "$(tr -d '\n' < "$TMP/a/plan/backlog/.next-id")" "AC-1: the counter file is unchanged"
assert_equals "$BEFORE" "$(git -C "$TMP/a" rev-parse HEAD)" "AC-1: no new commit"
assert_equals "" "$(git -C "$TMP/a" status --porcelain)" "AC-1: the tree is clean"

echo "=== req-001 AC-2: the message names the feat/ route ==="
assert_contains "feat/" "$OUT" "AC-2: stderr names feat/"
assert_contains "initiative/" "$OUT" "AC-2: stderr names initiative/"

echo "=== req-001 AC-3: other branches keep working ==="
make_repo b feat/demo
OUT=$(cd "$TMP/b" && node "$RESERVE" --commit 2>&1); RC=$?
assert_equals "0" "$RC" "AC-3: exits 0 on feat/"
assert_equals "0000100" "$OUT" "AC-3: prints the id"
assert_equals "chore(ids): reserve id 0000100" "$(git -C "$TMP/b" log -1 --format=%s)" "AC-3: commits the counter file"

make_repo c initiative/0000999-demo
OUT=$(cd "$TMP/c" && node "$RESERVE" 2>&1); RC=$?
assert_equals "0" "$RC" "AC-3: a run without --commit still reserves on initiative/*"
assert_equals "0000100" "$OUT" "AC-3: prints the id without --commit"
assert_equals "seed" "$(git -C "$TMP/c" log -1 --format=%s)" "AC-3: no commit without --commit"

print_summary
