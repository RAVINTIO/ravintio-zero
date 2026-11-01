#!/usr/bin/env bash
# Tests for feature 0000327-squash-before-main, req-001 AC-1 to AC-3 and NFR-001.
#
# check-pr-into-main.mjs fails a PR into main that breaks the branch or commit rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$SCRIPT_DIR/../scripts/check-pr-into-main.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

R="$TMP/repo"
mkdir -p "$R"
git -C "$R" init -q -b main
git -C "$R" config user.email t@example.com
git -C "$R" config user.name t
git -C "$R" config commit.gpgsign false
echo base > "$R/f"
git -C "$R" add f
git -C "$R" commit -q -m "base"

# Make a branch off main with N commits.
make_branch() {
  local name="$1" n="$2" i
  git -C "$R" checkout -q main
  git -C "$R" checkout -q -b "$name"
  for ((i = 1; i <= n; i++)); do
    echo "$name $i" > "$R/f"
    git -C "$R" commit -q -am "secret-body-$i" -m "BODY-TEXT-$i"
  done
  git -C "$R" checkout -q main
}

make_branch chore/one 1
make_branch chore/two 2
make_branch hotfix/one 1
make_branch hotfix/two 2
make_branch feat/x 1
make_branch initiative/y 3
git -C "$R" branch chore/zero main

# Usage: run_check HEADREF HEAD. Prints the exit code. Output goes to $TMP/out.
run_check() {
  node "$CHECK" --root "$R" --head-ref "$1" --base main --head "$2" >"$TMP/out" 2>&1
  echo $?
}

echo "=== req-001 AC-1: chore and hotfix commit count ==="
assert_equals "0" "$(run_check chore/one chore/one)" "AC-1: chore one commit exits 0"
assert_equals "1" "$(run_check chore/two chore/two)" "AC-1: chore two commits exits 1"
assert_equals "1" "$(run_check chore/zero chore/zero)" "AC-1: chore zero commits exits 1"
assert_equals "0" "$(run_check hotfix/one hotfix/one)" "AC-1: hotfix one commit exits 0"
assert_equals "1" "$(run_check hotfix/two hotfix/two)" "AC-1: hotfix two commits exits 1"

echo ""
echo "=== req-001 AC-2: other prefixes ==="
assert_equals "1" "$(run_check feat/x feat/x)" "AC-2: feat/x exits 1"
assert_equals "0" "$(run_check initiative/y initiative/y)" "AC-2: initiative/y exits 0"
assert_equals "0" "$(node "$CHECK" --root "$TMP/not-a-repo" --head-ref initiative/y --base nope --head nope >/dev/null 2>&1; echo $?)" "AC-2: initiative/ exits 0 before any git call"

echo ""
echo "=== req-001 AC-3: usage and git errors ==="
node "$CHECK" --root "$R" --base main --head chore/one >/dev/null 2>&1
assert_equals "2" "$?" "AC-3: missing --head-ref exits 2"
node "$CHECK" --root "$R" --head-ref chore/one --base nope --head chore/one >/dev/null 2>&1
assert_equals "2" "$?" "AC-3: unknown base exits 2"

node "$CHECK" --root "$R" --head-ref chore/one --base "--max-count=1" --head chore/one >/dev/null 2>&1
assert_equals "2" "$?" "AC-3: a --base that starts with a dash exits 2"
node "$CHECK" --root "$R" --head-ref chore/one --base main --head "--output=x" >/dev/null 2>&1
assert_equals "2" "$?" "AC-3: a --head that starts with a dash exits 2"

echo ""
echo "=== req-001: output names the ref and count, never bodies ==="
run_check chore/two chore/two >/dev/null
OUT="$(cat "$TMP/out")"
assert_contains "chore/two" "$OUT" "output names the head ref"
assert_contains "2" "$OUT" "output shows the count"
assert_not_contains "BODY-TEXT" "$OUT" "output has no commit body"
assert_not_contains "secret-body" "$OUT" "output has no commit subject"

echo ""
echo "=== NFR-001: two runs give the same exit code ==="
A="$(run_check chore/two chore/two)"
B="$(run_check chore/two chore/two)"
assert_equals "$A" "$B" "NFR-001: repeat run gives the same exit code"

print_summary
