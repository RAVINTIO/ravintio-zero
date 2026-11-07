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

# Writes a chart with a Steps table. Arguments: file, then "feature-id|Title" pairs.
make_chart() {
  local file="$1"; shift
  {
    echo "# Initiative: 0000319 - fixture"
    echo ""
    echo "## Steps"
    echo ""
    echo "| Step | Feature id | Title | Bump |"
    echo "|------|------------|-------|------|"
    local n=1 pair
    for pair in "$@"; do
      echo "| $n | ${pair%%|*} | ${pair#*|} | minor |"
      n=$((n + 1))
    done
  } > "$file"
}

echo "=== req-001 AC-1: titled squashes pass ==="
R="$(new_repo titled)"
make_chart "$TMP/titled.md" "0000319-initiative-history-checks|Add script" "0000320-other-thing2|Second change"
add_commit "$R" "0000319: Add script (#12)"
add_commit "$R" "0000320: Second change (#13)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/titled.md"
assert_equals "0" "$CODE" "req-001 AC-1: titled history exits 0"

echo ""
echo "=== req-001 AC-2: a direct commit fails and is named ==="
R="$(new_repo direct)"
make_chart "$TMP/direct.md" "0000319-initiative-history-checks|Add script"
add_commit "$R" "0000319: Add script (#12)"
add_commit "$R" "fix stuff"
HASH="$(git -C "$R" rev-parse --short HEAD)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/direct.md"
assert_equals "1" "$CODE" "req-001 AC-2: untitled commit exits 1"
assert_contains "$HASH" "$OUT" "req-001 AC-2: prints the short hash"
assert_contains "fix stuff" "$OUT" "req-001 AC-2: prints the subject"
case "$OUT" in
  *"Add script"*) assert_equals "absent" "present" "req-001 AC-2: titled commit not listed" ;;
  *) assert_equals "absent" "absent" "req-001 AC-2: titled commit not listed" ;;
esac

echo ""
echo "=== req-001 AC-2: near-miss titles fail ==="
make_chart "$TMP/near.md" "0000319-initiative-history-checks|Add script"
for subj in "0000319: Add script" "000319: Add script (#1)" "0000319: Add script (#x)" "0000319-slug: Add script (#1)" "0000319: Add scripts (#1)"; do
  R="$(new_repo "near$RANDOM")"
  add_commit "$R" "$subj"
  run_script --root "$R" --base main --head HEAD --chart "$TMP/near.md"
  assert_equals "1" "$CODE" "req-001 AC-2: rejects '$subj'"
done

echo ""
echo "=== req-001 AC-3: empty branch with charted steps fails ==="
R="$(new_repo empty)"
make_chart "$TMP/empty.md" "0000319-initiative-history-checks|Add script"
run_script --root "$R" --base main --head HEAD --chart "$TMP/empty.md"
assert_equals "1" "$CODE" "req-001 AC-3: missing step exits 1"
assert_contains "missing" "$OUT" "req-001 AC-3: names the missing step"

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
