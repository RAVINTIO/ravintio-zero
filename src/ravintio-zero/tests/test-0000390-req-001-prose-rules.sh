#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-001: the rules module and the
# check command find breaches of the writing standard.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LINT="$ZERO_DIR/scripts/prose-check.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/docs"

run_check() { (cd "$TMP" && node "$LINT" check "$@" 2>&1); }

echo ""
echo "=== AC-1: a 26-word sentence fails with the file and line ==="
cat > "$TMP/docs/long.md" <<'DOC'
# Title

Short intro.

One two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty twentyone twentytwo twentythree twentyfour twentyfive twentysix.
DOC
OUT="$(run_check --files docs/long.md)"; RC=$?
assert_equals "1" "$RC" "a 26-word sentence exits 1"
assert_contains "docs/long.md:5 sentence-length" "$OUT" "the output names the file, the line, and the rule"

echo ""
echo "=== AC-1: a 25-word sentence passes ==="
printf '%s\n' "One two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty twentyone twentytwo twentythree twentyfour twentyfive." > "$TMP/docs/edge.md"
OUT="$(run_check --files docs/edge.md)"; RC=$?
assert_equals "0" "$RC" "a 25-word sentence exits 0"

echo ""
echo "=== AC-2: code, tables, comments, and front matter are skipped ==="
LONG="one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty twentyone twentytwo twentythree twentyfour twentyfive twentysix"
{
  printf -- '---\ntitle: "%s; simply"\n---\n' "$LONG"
  printf '# Heading\n\n```\n%s; simply is done\n```\n\n' "$LONG"
  printf 'Use `%s; simply` here.\n\n' "$LONG"
  printf '| col | col |\n|---|---|\n| %s; simply | x |\n\n' "$LONG"
  printf '<!-- %s; simply -->\n\n' "$LONG"
  printf '<!--\n%s; simply\n-->\n' "$LONG"
} > "$TMP/docs/skip.md"
OUT="$(run_check --files docs/skip.md)"; RC=$?
assert_equals "0" "$RC" "skipped regions report no breach"
assert_contains "ok" "$OUT" "the run reports ok"

echo ""
echo "=== AC-3: the other rules fire ==="
{
  printf 'A line with a semicolon; here.\n\n'
  printf 'A line with a dash \xe2\x80\x94 here.\n\n'
  printf 'We simply use it.\n\n'
  printf 'The file is required.\n'
} > "$TMP/docs/rules.md"
OUT="$(run_check --files docs/rules.md)"; RC=$?
assert_equals "1" "$RC" "a file with four breaches exits 1"
assert_contains "semicolon" "$OUT" "the semicolon is reported"
assert_contains "em-dash" "$OUT" "the em dash is reported"
assert_contains "blocklist: \"simply\"" "$OUT" "the blocklist word is reported"
assert_contains "passive: \"is required\"" "$OUT" "the passive phrase is reported"

echo ""
echo "=== sentence splitting keeps abbreviations and file names whole ==="
printf '%s\n' "Use a tool, e.g. the linter, to check docs/about.md and version 0.70.0 files." > "$TMP/docs/abbr.md"
OUT="$(run_check --files docs/abbr.md)"; RC=$?
assert_equals "0" "$RC" "abbreviations and dots in names cause no breach"

echo ""
echo "=== message mode ==="
printf 'chore(0000390): add the check\n\n# a git comment; simply ignored\n%s.\n\nCo-authored-by: A Person <a@example.com>\n' "$LONG" > "$TMP/msg"
OUT="$(run_check --message msg)"; RC=$?
assert_equals "1" "$RC" "a long body sentence fails the message check"
assert_contains "message:3 sentence-length" "$OUT" "the message output names the line"
printf 'Merge branch main into feat\n\nAdd the check.\n' > "$TMP/msg2"
OUT="$(run_check --message msg2)"; RC=$?
assert_equals "0" "$RC" "a merge subject and a short body pass"
printf '# only a comment; simply\n' > "$TMP/msg3"
OUT="$(run_check --message msg3)"; RC=$?
assert_equals "0" "$RC" "comment lines are skipped"

echo ""
echo "=== usage errors ==="
(cd "$TMP" && node "$LINT" frob >/dev/null 2>&1); assert_equals "2" "$?" "an unknown command exits 2"

print_summary
