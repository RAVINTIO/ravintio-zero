#!/usr/bin/env bash
# Tests for feature 0000160-ravintio-rebrand, req-006: the brand guard (ADR-004).
#
# No tracked file outside history uses the retired brand word. This test reads
# `git ls-files`, drops the excluded prefixes, and searches the rest for the
# word, case-insensitive. It checks paths and lines.
#
# A path or line passes only if an allowlist entry covers it. A line entry is a
# path regex and a line regex, and both must match. Any other match fails the
# test, and the test prints the file and line number.
#
# A stale allowlist entry that matches no line also fails the test.
#
# A second case adds the word to a scratch copy of README.md and expects the
# check to flag it. A third case feeds a path with the word to the path check.
#
# This source never writes the word as one token where a scan could match it
# outside its own allowlist entry. Its own path is allowlisted, so it may.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"

# The excluded prefixes and the allowlist live in one file that the pre-push
# hook also reads (0000394 ADR-001). brand_guard_load fills EXCLUDED_PREFIXES
# and ALLOWLIST. A line entry is "path regex<TAB>line regex".
TAB=$'\t'
source "$REPO_ROOT/ravintio-zero/scripts/brand-guard.sh"
brand_guard_load "$SCRIPT_DIR/brand-guard-allowlist.txt"

# Path allowlist. Each entry is a path regex. No tracked path may name the
# brand word today, so the list is empty. Add an entry with a reason.
PATH_ALLOWLIST=()

# Hit counts per entry, used by the stale-entry check.
declare -a HITS
for _i in "${!ALLOWLIST[@]}"; do HITS[$_i]=0; done
COUNT_HITS=1

# Returns 0 when an entry covers the line. Counts every covering entry while
# COUNT_HITS is 1, so the stale check sees overlapping entries.
allowed() {
  local path="$1" text="$2" i entry path_re line_re found=1
  for i in "${!ALLOWLIST[@]}"; do
    entry="${ALLOWLIST[$i]}"
    path_re="${entry%%"$TAB"*}"
    line_re="${entry#*"$TAB"}"
    if [[ "$path" =~ $path_re ]] && [[ "$text" =~ $line_re ]]; then
      found=0
      [ "$COUNT_HITS" -eq 1 ] && HITS[$i]=$(( ${HITS[$i]} + 1 ))
    fi
  done
  return "$found"
}

# Reads relative paths on stdin, searches each under root $1, and prints
# "path:line" for every matching line that no allowlist entry covers.
check_lines() {
  local root="$1" path num text hit
  while IFS= read -r path; do
    [ -f "$root/$path" ] || continue
    while IFS= read -r hit; do
      [ -n "$hit" ] || continue
      num="${hit%%:*}"
      text="${hit#*:}"
      allowed "$path" "$text" || echo "$path:$num"
    done <<< "$(grep -inI -- planifest "$root/$path" 2>/dev/null)"
  done
}

# Reads relative paths on stdin and prints each path that names the word and
# matches no path allowlist entry.
check_paths() {
  local path re ok
  while IFS= read -r path; do
    printf '%s\n' "$path" | grep -qi -- planifest || continue
    ok=1
    for re in ${PATH_ALLOWLIST[@]+"${PATH_ALLOWLIST[@]}"}; do
      [[ "$path" =~ $re ]] && ok=0
    done
    [ "$ok" -eq 0 ] || echo "$path"
  done
}

in_scope_files() {
  local path prefix keep
  git -C "$REPO_ROOT" ls-files | while IFS= read -r path; do
    keep=1
    for prefix in "${EXCLUDED_PREFIXES[@]}"; do
      case "$path" in "$prefix"*) keep=0; break ;; esac
    done
    [ "$keep" -eq 1 ] && echo "$path"
  done
}

echo ""
echo "=== req-006 (a): tracked lines use the word only in allowlisted ways ==="

SCOPE="$(in_scope_files)"
STRAY="$(printf '%s\n' "$SCOPE" | check_lines "$REPO_ROOT")"
# The check ran in a subshell, so count the hits again here in this shell.
while IFS= read -r p; do
  [ -f "$REPO_ROOT/$p" ] || continue
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    allowed "$p" "${hit#*:}" || true
  done <<< "$(grep -inI -- planifest "$REPO_ROOT/$p" 2>/dev/null)"
done <<< "$SCOPE"
COUNT_HITS=0
if [ -n "$STRAY" ]; then
  echo "  Lines outside the allowlist:"
  printf '    %s\n' $STRAY
fi
assert_equals "" "$STRAY" "req-006 (a): no tracked line outside the allowlist uses the word"

echo ""
echo "=== req-006 (b): no tracked path names the word outside the allowlist ==="

STRAY_PATHS="$(printf '%s\n' "$SCOPE" | check_paths)"
if [ -n "$STRAY_PATHS" ]; then
  echo "  Paths outside the allowlist:"
  printf '    %s\n' $STRAY_PATHS
fi
assert_equals "" "$STRAY_PATHS" "req-006 (b): no tracked path outside the allowlist names the word"

echo ""
echo "=== req-006 (c): every line allowlist entry matches at least one line ==="

STALE=""
for i in "${!ALLOWLIST[@]}"; do
  [ "${HITS[$i]}" -eq 0 ] && STALE="${STALE}entry $i: ${ALLOWLIST[$i]%%"$TAB"*} / ${ALLOWLIST[$i]#*"$TAB"}"$'\n'
done
if [ -n "$STALE" ]; then
  echo "  Stale allowlist entries:"
  printf '    %s\n' "$STALE"
fi
assert_equals "" "$STALE" "req-006 (c): no allowlist entry is stale"

echo ""
echo "=== req-006 (d): a planted line in a scratch README.md fails the check ==="

SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
cp "$REPO_ROOT/README.md" "$SCRATCH/README.md"
echo "Planifest Zero is the old name" >> "$SCRATCH/README.md"
PLANTED_LINE="$(wc -l < "$SCRATCH/README.md" | tr -d ' ')"
PLANTED="$(echo "README.md" | check_lines "$SCRATCH")"
assert_contains "README.md:$PLANTED_LINE" "$PLANTED" \
  "req-006 (d): the check flags the planted line with its file and line number"

echo ""
echo "=== req-006 (e): a path that names the word fails the path check ==="

PLANTED_PATH="$(echo "docs/Planifest-notes.md" | check_paths)"
assert_equals "docs/Planifest-notes.md" "$PLANTED_PATH" \
  "req-006 (e): the path check flags a path that names the word"

print_summary
