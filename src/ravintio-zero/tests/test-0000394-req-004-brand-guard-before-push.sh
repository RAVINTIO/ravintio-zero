#!/usr/bin/env bash
# Tests for feature 0000394-github-security-and-ci-lint, req-004: the brand
# guard runs from pre-push with the allowlist that CI uses (ADR-001).
#
# A scratch repo holds a copy of the hook, the guard script, the allowlist, and
# a product.yml. Its origin/main ref sits on the first commit, so the hook
# checks the files that the branch adds.
#
# This source never writes the retired word as one token. It joins two halves.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
WORD="plani""fest"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# make_repo <dir> <product id>: scratch repo with origin/main on its first commit.
make_repo() {
  local dir="$1" pid="$2"
  mkdir -p "$dir/ravintio-zero/hooks" "$dir/ravintio-zero/scripts" "$dir/ravintio-zero/tests"
  git -C "$dir" init -q -b main
  git -C "$dir" config user.email t@example.com
  git -C "$dir" config user.name t
  cp "$ZERO_DIR/hooks/pre-push" "$dir/ravintio-zero/hooks/pre-push"
  cp "$ZERO_DIR/scripts/brand-guard.sh" "$dir/ravintio-zero/scripts/brand-guard.sh"
  cp "$ZERO_DIR/tests/brand-guard-allowlist.txt" "$dir/ravintio-zero/tests/brand-guard-allowlist.txt"
  printf 'id: "%s"\n' "$pid" > "$dir/product.yml"
  echo "base" > "$dir/README.md"
  git -C "$dir" add -A
  git -C "$dir" commit -q -m base
  git -C "$dir" update-ref refs/remotes/origin/main HEAD
  git -C "$dir" checkout -q -b feat/x
}

# push_check <dir>: runs the hook the way git does, from the repo root.
push_check() {
  ( cd "$1" && bash ravintio-zero/hooks/pre-push 2>&1 )
}

echo ""
echo "=== req-004 AC-1: a push with the old name fails and names the file and line ==="
R1="$TMP/r1"
make_repo "$R1" "ravintio-zero"
mkdir -p "$R1/docs"
printf 'line one\nThe %s name returned here\n' "$(printf '%s' "$WORD" | sed 's/^./P/')" > "$R1/docs/note.md"
git -C "$R1" add -A && git -C "$R1" commit -q -m add
OUT="$(push_check "$R1")"; RC=$?
assert_equals "1" "$RC" "req-004 AC-1: the hook exits 1"
assert_contains "docs/note.md:2" "$OUT" "req-004 AC-1: the output names the file and line"

echo ""
echo "=== req-004 AC-2: a clean push passes ==="
R2="$TMP/r2"
make_repo "$R2" "ravintio-zero"
mkdir -p "$R2/docs"
echo "clean text" > "$R2/docs/note.md"
git -C "$R2" add -A && git -C "$R2" commit -q -m add
OUT="$(push_check "$R2")"; RC=$?
assert_equals "0" "$RC" "req-004 AC-2: the hook exits 0"

echo ""
echo "=== req-004: an excluded prefix passes ==="
R3="$TMP/r3"
make_repo "$R3" "ravintio-zero"
mkdir -p "$R3/plan/_archive/x"
echo "the $WORD name in history" > "$R3/plan/_archive/x/old.md"
git -C "$R3" add -A && git -C "$R3" commit -q -m add
OUT="$(push_check "$R3")"; RC=$?
assert_equals "0" "$RC" "req-004: a hit under an excluded prefix passes"

echo ""
echo "=== req-004: a consumer repo skips the guard ==="
R4="$TMP/r4"
make_repo "$R4" "some-consumer"
mkdir -p "$R4/docs"
echo "the $WORD name" > "$R4/docs/note.md"
git -C "$R4" add -A && git -C "$R4" commit -q -m add
OUT="$(push_check "$R4")"; RC=$?
assert_equals "0" "$RC" "req-004: a repo with another product id passes"

echo ""
echo "=== req-004 NFR-001: the guard checks 100 files in under 5 seconds ==="
R5="$TMP/r5"
make_repo "$R5" "ravintio-zero"
mkdir -p "$R5/docs"
i=0
while [ "$i" -lt 100 ]; do
  printf 'clean line %s\nanother line\n' "$i" > "$R5/docs/f$i.md"
  i=$((i + 1))
done
git -C "$R5" add -A && git -C "$R5" commit -q -m add
START="$(date +%s)"
OUT="$(push_check "$R5")"; RC=$?
END="$(date +%s)"
assert_equals "0" "$RC" "req-004 NFR-001: the clean 100-file push passes"
if [ $((END - START)) -lt 5 ]; then
  assert_equals "ok" "ok" "req-004 NFR-001: the check took under 5 seconds"
else
  assert_equals "under 5 seconds" "$((END - START)) seconds" "req-004 NFR-001: the check took under 5 seconds"
fi

echo ""
echo "=== req-004 AC-3: the hook, the script, and the CI test share one allowlist ==="
HOOK="$(cat "$ZERO_DIR/hooks/pre-push")"
GUARD="$(cat "$ZERO_DIR/scripts/brand-guard.sh")"
CITEST="$(cat "$SCRIPT_DIR/test-0000160-req-006-brand-guard.sh")"
assert_contains "brand-guard.sh" "$HOOK" "req-004 AC-3: pre-push runs the guard script"
assert_contains "brand-guard-allowlist.txt" "$GUARD" "req-004 AC-3: the script names the shared file"
assert_contains "brand-guard-allowlist.txt" "$CITEST" "req-004 AC-3: the CI test names the shared file"
assert_equals "0" "$(printf '%s\n' "$CITEST" | grep -c '^  "\^README')" "req-004 AC-3: the CI test holds no inline entry"
assert_equals "0" "$(printf '%s\n' "$GUARD" | grep -c '^  "\^README')" "req-004 AC-3: the script holds no inline entry"

print_summary
