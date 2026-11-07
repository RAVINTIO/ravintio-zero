#!/usr/bin/env bash
# Tests for feature 0000351-step-titles-and-history-shape, req-003.
#
# The history script matches each step title and allows one chore commit.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="$SCRIPT_DIR/../scripts/check-initiative-history.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Builds a repo with one base commit on main and an initiative branch named $2.
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
  git -C "$dir" checkout -q -b "${2:-initiative/0000400-fixture}"
  echo "$dir"
}

add_commit() {
  echo "$2" >> "$1/f"
  git -C "$1" commit -q -am "$2"
}

# Writes a chart. Arguments: file, header row, then data rows.
write_chart() {
  local file="$1" header="$2"; shift 2
  {
    echo "# Initiative: 0000400 - fixture"
    echo ""
    echo "## Steps"
    echo ""
    echo "$header"
    echo "|---|---|---|"
    local row
    for row in "$@"; do echo "$row"; done
  } > "$file"
}

HEAD3='| Step | Feature id | Title |'
chart3() {
  write_chart "$1" "$HEAD3" \
    "| 1 | 0000401-first-thing | First thing |" \
    "| 2 | 0000402-second-thing | Second thing |" \
    "| 3 | 0000403-third-thing | Third thing |"
}

run_script() {
  OUT="$(node "$SCRIPT" "$@" 2>&1)"
  CODE=$?
}

steps() {
  add_commit "$1" "0000401: First thing (#1)"
  add_commit "$1" "0000402: Second thing (#2)"
  add_commit "$1" "0000403: Third thing (#3)"
}

echo "=== req-003 AC-1: steps plus chore pass ==="
R="$(new_repo ok)"; chart3 "$TMP/ok.md"
steps "$R"; add_commit "$R" "0000400: Initiative admin (#4)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "0" "$CODE" "req-003 AC-1: steps and chore exit 0"

echo ""
echo "=== req-003 AC-1: steps without chore pass ==="
R="$(new_repo nochore)"
steps "$R"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "0" "$CODE" "req-003 AC-1: steps only exit 0"

echo ""
echo "=== req-003 AC-2: mistitled step fails and is named ==="
R="$(new_repo mistitled)"
add_commit "$R" "0000401: First thing (#1)"
add_commit "$R" "0000402: Second thin (#2)"
HASH="$(git -C "$R" rev-parse --short HEAD)"
add_commit "$R" "0000403: Third thing (#3)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "1" "$CODE" "req-003 AC-2: mistitled step exits 1"
assert_contains "$HASH" "$OUT" "req-003 AC-2: prints the short hash"
assert_contains "Second thin" "$OUT" "req-003 AC-2: prints the subject"

echo ""
echo "=== req-003 AC-3: extra commit between steps fails and is named ==="
R="$(new_repo extra)"
add_commit "$R" "0000401: First thing (#1)"
add_commit "$R" "stray work"
HASH="$(git -C "$R" rev-parse --short HEAD)"
add_commit "$R" "0000402: Second thing (#2)"
add_commit "$R" "0000403: Third thing (#3)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "1" "$CODE" "req-003 AC-3: extra commit exits 1"
assert_contains "$HASH" "$OUT" "req-003 AC-3: prints the short hash"
assert_contains "stray work" "$OUT" "req-003 AC-3: prints the subject"

echo ""
echo "=== req-003: two chore commits fail ==="
R="$(new_repo twochore)"
steps "$R"
add_commit "$R" "0000400: Initiative admin (#4)"
add_commit "$R" "0000400: Initiative admin (#5)"
HASH="$(git -C "$R" rev-parse --short HEAD)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "1" "$CODE" "req-003: two chore commits exit 1"
assert_contains "$HASH" "$OUT" "req-003: prints the second chore commit"

echo ""
echo "=== req-003: a missing step fails ==="
R="$(new_repo missing)"
add_commit "$R" "0000401: First thing (#1)"
add_commit "$R" "0000402: Second thing (#2)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "1" "$CODE" "req-003: missing step exits 1"
assert_contains "Third thing" "$OUT" "req-003: names the missing step"

echo ""
echo "=== req-003: steps in the wrong order fail ==="
R="$(new_repo order)"
add_commit "$R" "0000402: Second thing (#2)"
add_commit "$R" "0000401: First thing (#1)"
add_commit "$R" "0000403: Third thing (#3)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/ok.md"
assert_equals "1" "$CODE" "req-003: wrong order exits 1"

echo ""
echo "=== req-003: missing Title column fails with a message ==="
R="$(new_repo notitle)"
write_chart "$TMP/notitle.md" "| Step | Feature id | Bump |" "| 1 | 0000401-first-thing | minor |"
add_commit "$R" "0000401: First thing (#1)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/notitle.md"
assert_equals "1" "$CODE" "req-003: missing column exits 1"
assert_contains "Title" "$OUT" "req-003: names the Title column"

echo ""
echo "=== req-003: missing chart names the paths tried ==="
R="$(new_repo nochart)"
add_commit "$R" "0000401: First thing (#1)"
run_script --root "$R" --base main --head HEAD
assert_equals "1" "$CODE" "req-003: missing chart exits 1"
assert_contains "initiative.md" "$OUT" "req-003: names a chart path"

echo ""
echo "=== req-003: archived chart is found by id from --head ==="
R="$(new_repo archived initiative/0000400-fixture)"
mkdir -p "$R/plan/_archive/0000400-fixture-initiative-2026-11-05"
chart3 "$R/plan/_archive/0000400-fixture-initiative-2026-11-05/initiative.md"
steps "$R"
git -C "$R" update-ref refs/remotes/origin/initiative/0000400-fixture HEAD
run_script --root "$R" --base main --head origin/initiative/0000400-fixture
assert_equals "0" "$CODE" "req-003: archived chart default exits 0"

echo ""
echo "=== req-003: current chart is the first default ==="
R="$(new_repo current)"
mkdir -p "$R/plan/current-initiative"
chart3 "$R/plan/current-initiative/initiative.md"
steps "$R"
run_script --root "$R" --base main --head HEAD
assert_equals "0" "$CODE" "req-003: current-initiative chart default exits 0"

echo ""
echo "=== req-003: special characters in a title match exactly ==="
R="$(new_repo special)"
write_chart "$TMP/special.md" "$HEAD3" "| 1 | 0000401-first-thing | a.b (x)+ |"
add_commit "$R" "0000401: a.b (x)+ (#1)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/special.md"
assert_equals "0" "$CODE" "req-003: special characters match exactly"
R="$(new_repo special2)"
add_commit "$R" "0000401: aXb (x)+ (#1)"
run_script --root "$R" --base main --head HEAD --chart "$TMP/special.md"
assert_equals "1" "$CODE" "req-003: a dot does not act as a wildcard"

print_summary
