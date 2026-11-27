#!/usr/bin/env bash
# Tests for feature 0000550-no-head-diffs-in-tests, req-001 and req-002: guard.
#
# A test that diffs a file against HEAD or a moving ref passes with no change
# once someone commits the work. No suite under tests/ may run such a diff.
# The testing standard carries the rule. This suite enforces it.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
SELF="$SCRIPT_DIR/$(basename "$0")"
ZERO_DIR="$SCRIPT_DIR/.."

# Built from parts so this file never holds a line the pattern matches.
GIT="gi""t"
DIFF="dif""f"
PATTERN="^([^#]*[^[:alnum:]_#-])?${GIT}[^|;&#]*[[:space:]]${DIFF}(-index)?([[:space:]][^|;&#]*)?[[:space:]](HEAD|ORIG_HEAD|FETCH_HEAD|@)([~^][0-9]*)?([[:space:]]|\$|:|\"|'|\))"

# Prints each file under the directory $1 that holds a diff against a moving ref, except this file.
offenders() {
  local f
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ "$f" = "$SELF" ] && continue
    grep -qE -- "$PATTERN" "$f" 2>/dev/null && echo "${f#"$1"/}"
  done <<< "$(find "$1" \( -type f -o -type l \) \( -name '*.sh' -o -name '*.ps1' -o -name '*.mjs' \) | LC_ALL=C sort)"
}

echo "=== req-001: the testing standard names the rule ==="
assert_rule tests-no-head-diff "HEAD" "moving ref" "working tree"

echo "=== req-002: no suite diffs against HEAD or a moving ref ==="
assert_equals "" "$(offenders "$SCRIPT_DIR")" "no file under tests/ runs a diff against HEAD or a moving ref"

echo "=== req-002: the check detects planted files ==="
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
printf '%s %s HEAD -- file\n' "$GIT" "$DIFF" > "$TMP/bad-head.sh"
printf '%s %s --quiet HEAD~1 -- file\n' "$GIT" "$DIFF" > "$TMP/bad-tilde.sh"
printf '%s %s @ -- file\n' "$GIT" "$DIFF" > "$TMP/bad-at.sh"
printf '(cd d && %s -C d %s --name-only ORIG_HEAD)\n' "$GIT" "$DIFF" > "$TMP/bad-orig.sh"
printf '%s %s-index --quiet HEAD\n' "$GIT" "$DIFF" > "$TMP/bad-index.sh"
printf '%s %s --cached HEAD\n' "$GIT" "$DIFF" > "$TMP/bad-cached.sh"
printf '%s %s origin/main...HEAD\n' "$GIT" "$DIFF" > "$TMP/ok-range.sh"
printf '%s %s abc1234 -- file\n' "$GIT" "$DIFF" > "$TMP/ok-sha.sh"
printf 'lint %s --base HEAD\n' "$DIFF" > "$TMP/ok-flag.sh"
printf '# %s %s HEAD is banned\n' "$GIT" "$DIFF" > "$TMP/ok-comment.sh"
EXPECTED="bad-at.sh
bad-cached.sh
bad-head.sh
bad-index.sh
bad-orig.sh
bad-tilde.sh"
assert_equals "$EXPECTED" "$(offenders "$TMP")" "the check flags every planted diff and no other file"

print_summary
