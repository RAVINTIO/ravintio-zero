#!/usr/bin/env bash
# Feature 0000393 req-004: the filing skill runs the entry wording check.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$ZERO_DIR/scripts/check-entry-wording.mjs"
SKILL="$ZERO_DIR/skills/ravintio-file-backlog/SKILL.md"

# Build the banned words from parts so this file never holds either as one token.
FW="frame""work"
OLD="plani""fest"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

printf '# Entry\n\nRAVINTIO Zero is a %s for teams.\n' "$FW" > "$TMP/bad.md"
printf '# Entry\n\nThe %s name is retired.\n' "$OLD" > "$TMP/brand.md"
printf '# Entry\n\nPlain wording only.\n' > "$TMP/clean.md"
printf '# Entry\n\nRun the test %s and the meta-%s.\n' "$FW" "$FW" > "$TMP/allowed.md"

echo "=== req-004 AC-1: a banned phrase exits 1 and names file and line ==="
OUT="$(node "$CHECK" "$TMP/bad.md" 2>/dev/null)"; RC=$?
assert_equals "1" "$RC" "req-004: banned phrase exits 1"
assert_equals "$TMP/bad.md:3" "$OUT" "req-004: prints file:line"
OUT="$(node "$CHECK" "$TMP/brand.md" 2>/dev/null)"; RC=$?
assert_equals "1" "$RC" "req-004: retired brand word exits 1"
assert_equals "$TMP/brand.md:3" "$OUT" "req-004: prints file:line for the brand word"

echo "=== req-004 AC-2: clean and allowlisted entries exit 0 ==="
node "$CHECK" "$TMP/clean.md" >/dev/null 2>&1; RC=$?
assert_equals "0" "$RC" "req-004: clean entry exits 0"
node "$CHECK" "$TMP/allowed.md" >/dev/null 2>&1; RC=$?
assert_equals "0" "$RC" "req-004: allowlisted phrase exits 0"

echo "=== req-004: usage and unreadable file exit 2 ==="
node "$CHECK" "$TMP/missing.md" >/dev/null 2>&1; RC=$?
assert_equals "2" "$RC" "req-004: missing file exits 2"
node "$CHECK" >/dev/null 2>&1; RC=$?
assert_equals "2" "$RC" "req-004: no arguments exits 2"

echo "=== req-004 AC-3: the skill runs the check before the report step ==="
BODY="$(cat "$SKILL" 2>/dev/null)"
assert_contains "check-entry-wording.mjs" "$BODY" "req-004: skill names the script"
S6="$(grep -n "^## Step 6" "$SKILL" | cut -d: -f1)"
S7="$(grep -n "^## Step 7" "$SKILL" | cut -d: -f1)"
RUN="$(grep -n "check-entry-wording.mjs" "$SKILL" | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$S6" ] && [ -n "$S7" ] && [ -n "$RUN" ] && [ "$RUN" -gt "$S6" ] && [ "$RUN" -lt "$S7" ] && echo yes || echo no)" \
  "req-004: the script runs inside Step 6, before Step 7"

print_summary
