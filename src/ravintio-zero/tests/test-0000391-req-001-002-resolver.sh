#!/usr/bin/env bash
# Tests for feature 0000391-standards-archetypes, REQ-001 and REQ-002: the override resolver and protected rules.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Consumer layout: the pack sits at $TMP/ravintio-zero and overrides at $TMP/ravintio-overrides.
mkdir -p "$TMP/ravintio-zero/standards" "$TMP/ravintio-zero/templates" "$TMP/ravintio-zero/scripts" "$TMP/ravintio-zero/archetypes"
cp "$ZERO_DIR/scripts/resolve-override.mjs" "$TMP/ravintio-zero/scripts/" 2>/dev/null
cp "$ZERO_DIR/archetypes/protected.json" "$TMP/ravintio-zero/archetypes/" 2>/dev/null
cp "$ZERO_DIR/standards/writing-standards.md" "$ZERO_DIR/standards/commit-standards.md" "$TMP/ravintio-zero/standards/"
printf 'pack template\n' > "$TMP/ravintio-zero/templates/t.md"
printf 'pack standard\n' > "$TMP/ravintio-zero/standards/other.md"
mkdir -p "$TMP/ravintio-overrides/standards" "$TMP/ravintio-overrides/templates"

run() { (cd "$TMP" && node "$TMP/ravintio-zero/scripts/resolve-override.mjs" "$@" --root "$TMP" 2>&1); }

echo ""
echo "=== req-001 AC-1: override wins ==="
printf 'my template\n' > "$TMP/ravintio-overrides/templates/t.md"
OUT="$(run templates t.md)"; RC=$?
assert_equals "0" "$RC" "req-001 override lookup exits 0"
assert_equals "$TMP/ravintio-overrides/templates/t.md" "$OUT" "req-001 returns the override path"
OUT2="$(run templates t.md)"
assert_equals "$OUT" "$OUT2" "req-001 gives the same result on every run"

echo ""
echo "=== req-001 AC-2: pack copy as fallback ==="
OUT="$(run standards other.md)"; RC=$?
assert_equals "0" "$RC" "req-001 fallback exits 0"
assert_equals "$TMP/ravintio-zero/standards/other.md" "$OUT" "req-001 returns the pack path"

echo ""
echo "=== req-001 AC-3: unsafe path refused ==="
OUT="$(run standards ../../etc/passwd)"; RC=$?
assert_equals "1" "$RC" "req-001 traversal exits 1"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c '^/')" "req-001 traversal returns no path"
printf 'real\n' > "$TMP/real.md"
ln -s "$TMP/real.md" "$TMP/ravintio-overrides/standards/other.md"
OUT="$(run standards other.md)"; RC=$?
assert_equals "1" "$RC" "req-001 symlink exits 1"
assert_not_contains "real.md" "$OUT" "req-001 symlink target is never returned"
rm "$TMP/ravintio-overrides/standards/other.md"

echo ""
echo "=== req-002 AC-1: ignored file ==="
printf 'relaxed commit rules\n' > "$TMP/ravintio-overrides/standards/commit-standards.md"
OUT="$(run standards commit-standards.md)"; RC=$?
assert_equals "0" "$RC" "req-002 ignore entry exits 0"
assert_equals "$TMP/ravintio-zero/standards/commit-standards.md" "$OUT" "req-002 ignore entry returns the pack copy"
for f in hook-enforcement roadmap-standards workflow-governance-standards; do
  assert_contains '"standards/'"$f"'.md"' "$(cat "$ZERO_DIR/archetypes/protected.json" 2>/dev/null)" "req-002 lists $f as protected"
done

echo ""
echo "=== req-002 AC-2: pinned line dropped ==="
grep -v 'Do not use em dashes or semicolons. End the sentence' "$ZERO_DIR/standards/writing-standards.md" > "$TMP/ravintio-overrides/standards/writing-standards.md"
OUT="$(run standards writing-standards.md)"; RC=$?
assert_equals "0" "$RC" "req-002 dropped pin exits 0"
assert_equals "$TMP/ravintio-zero/standards/writing-standards.md" "$OUT" "req-002 dropped pin returns the pack copy"

echo ""
echo "=== req-002 AC-3: pinned lines kept ==="
{ cat "$ZERO_DIR/standards/writing-standards.md"; printf 'Extra team rule.\n'; } > "$TMP/ravintio-overrides/standards/writing-standards.md"
OUT="$(run standards writing-standards.md)"; RC=$?
assert_equals "0" "$RC" "req-002 kept pins exits 0"
assert_equals "$TMP/ravintio-overrides/standards/writing-standards.md" "$OUT" "req-002 kept pins returns the override"

print_summary
