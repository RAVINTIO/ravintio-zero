#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, req-007: writing-style.mjs
# reads the writing standard through the override resolver.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PACK_STD="$ZERO_DIR/standards/writing-standards.md"
US_STD="$ZERO_DIR/archetypes/alternative/us-writing/files/standards/writing-standards.md"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# A consumer repo with the pack copied to {tmp}/ravintio-zero.
CONSUMER="$TMP/consumer"
mkdir -p "$CONSUMER/ravintio-zero"
for d in scripts standards archetypes; do cp -R "$ZERO_DIR/$d" "$CONSUMER/ravintio-zero/$d"; done
GEN="$CONSUMER/ravintio-zero/scripts/writing-style.mjs"
OV="$CONSUMER/ravintio-overrides/standards"

# Expected pack text, from the pack file passed explicitly.
EXP_CC="$(node "$GEN" claude-code "$PACK_STD")"
EXP_CX="$(node "$GEN" codex "$PACK_STD")"

echo ""
echo "=== no override: output matches the pack text ==="
assert_equals "$EXP_CC" "$(node "$GEN" claude-code)" "claude-code output matches the pack text"
assert_equals "$EXP_CX" "$(node "$GEN" codex)" "codex output matches the pack text"
assert_contains 'Read `ravintio-zero/standards/writing-standards.md` for the full rules.' "$(node "$GEN" codex)" "codex pointer names the pack file"

echo ""
echo "=== us-writing override ==="
mkdir -p "$OV"
cp "$US_STD" "$OV/writing-standards.md"
OUT="$(node "$GEN" claude-code)"
assert_contains "American spelling" "$OUT" "claude-code output carries the US spelling rule"
assert_not_contains "Use British spelling" "$OUT" "claude-code output drops the British rule"
OUT="$(node "$GEN" codex)"
assert_contains "American English spelling" "$OUT" "codex output carries the US spelling rule"
assert_contains 'Read `ravintio-overrides/standards/writing-standards.md` for the full rules.' "$OUT" "codex pointer names the override file"

echo ""
echo "=== explicit path wins ==="
assert_equals "$EXP_CC" "$(node "$GEN" claude-code "$PACK_STD")" "explicit path beats the override"

echo ""
echo "=== --root option ==="
OUT="$(cd "$TMP" && node "$GEN" codex --root "$CONSUMER")"
assert_contains "American English spelling" "$OUT" "--root selects the consumer root"

echo ""
echo "=== override drops a pinned line ==="
grep -v "Do not use em dashes or semicolons" "$US_STD" > "$OV/writing-standards.md"
assert_equals "$EXP_CC" "$(node "$GEN" claude-code)" "claude-code falls back to the pack text"
assert_equals "$EXP_CX" "$(node "$GEN" codex)" "codex falls back to the pack text"

print_summary
