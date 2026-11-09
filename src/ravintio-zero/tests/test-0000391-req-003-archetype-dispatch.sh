#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, REQ-003 AC-3: setup.sh and setup.ps1
# dispatch the archetype verb to scripts/archetype.mjs and print the same output.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PWSH="${RAVINTIO_PWSH:-pwsh}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ln -s "$ZERO_DIR" "$TMP/ravintio-zero"

echo ""
echo "=== req-003 AC-3: list through setup.sh ==="
EXPECT="$(cd "$TMP" && node "$ZERO_DIR/scripts/archetype.mjs" list --root "$TMP")"
OUT="$(cd "$TMP" && bash ravintio-zero/setup.sh archetype list 2>&1)"; RC=$?
assert_equals "0" "$RC" "setup.sh archetype list exits 0"
assert_equals "$EXPECT" "$OUT" "setup.sh prints what archetype.mjs prints"

echo ""
echo "=== req-003 AC-1: use through setup.sh ==="
OUT="$(cd "$TMP" && bash ravintio-zero/setup.sh archetype use alternative/us-writing 2>&1)"; RC=$?
assert_equals "0" "$RC" "setup.sh archetype use exits 0"
assert_contains "installed" "$OUT" "the use command reports the install"
[ -f "$TMP/ravintio-overrides/archetypes.json" ] && assert_contains ok ok "the pick is recorded in the consumer repo" || assert_contains ok missing "the pick is recorded in the consumer repo"
OUT="$(cd "$TMP" && bash ravintio-zero/setup.sh archetype use constraint/nope 2>&1)"; RC=$?
assert_equals "1" "$RC" "an unknown archetype exits 1"

echo ""
echo "=== req-003 AC-3: list through setup.ps1 ==="
if command -v "$PWSH" >/dev/null 2>&1; then
  PS_OUT="$(cd "$TMP" && "$PWSH" -NoProfile -File ravintio-zero/setup.ps1 archetype list 2>&1 | tr -d '\r')"
  assert_equals "$EXPECT" "$PS_OUT" "setup.ps1 prints what setup.sh prints"
else
  echo "  SKIP: pwsh not installed"
fi

assert_summary 2>/dev/null || true
