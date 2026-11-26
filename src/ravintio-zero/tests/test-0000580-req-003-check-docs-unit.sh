#!/usr/bin/env bash
# Test: 0000580 req-003 check-docs-unit
# build-log-check.mjs check 7 requires both markers for a docs Done line.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$ZERO_DIR/scripts/build-log-check.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
run_check() { OUT=$(node "$CHECK" "$1" 2>&1); CODE=$?; }

echo "=== AC-1: a docs unit with both markers has no finding ==="
cat > "$TMP/ok.md" <<'LOG'
# Log

### P2: Implement

- RED: U9 docs (docs, 2026-11-26T10:00:00Z)
- GREEN: U9 docs (docs, 2026-11-26T10:01:00Z)
- Done: U9 docs (docs, cheaper, low, 2026-11-26T10:02:00Z)
LOG
run_check "$TMP/ok.md"
assert_not_contains "Unit U9" "$OUT" "AC-1: no finding names U9"

echo "=== AC-2: a docs unit with no marker fails ==="
cat > "$TMP/bad.md" <<'LOG'
# Log

### P2: Implement

- Done: U8 docs (docs, cheaper, low, 2026-11-26T10:02:00Z)
LOG
run_check "$TMP/bad.md"
assert_equals "1" "$CODE" "AC-2: the check exits 1"
assert_contains 'Unit U8 docs: inline "Done:" line has no "RED: U8 docs" line' "$OUT" "AC-2: names the missing RED line"
assert_contains 'no "GREEN: U8 docs" line' "$OUT" "AC-2: names the missing GREEN line"

echo "=== AC-3: an older Done line has no finding ==="
cat > "$TMP/old.md" <<'LOG'
# Log

### P2: Implement

- Done: U7 old (2026-11-26T10:02:00Z)
- Done: U6 content (content, cheaper, low, 2026-11-26T10:03:00Z)
LOG
run_check "$TMP/old.md"
assert_not_contains "Unit U7" "$OUT" "AC-3: no finding names U7"
assert_not_contains "Unit U6" "$OUT" "AC-3: no finding names U6"

print_summary
