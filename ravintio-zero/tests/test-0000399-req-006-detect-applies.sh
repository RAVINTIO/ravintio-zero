#!/usr/bin/env bash
# Tests for feature 0000399 REQ-006: resume-detect.mjs prints a pending line
# only for a migration that applies.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="${RESUME_DETECT:-$SCRIPT_DIR/../scripts/resume-detect.mjs}"
REAL_MIG="$SCRIPT_DIR/../migrations"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

new_ws() { local w; w="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"; mkdir -p "$w/ravintio-zero/migrations" "$w/plan/state"; echo "$w"; }
detect() { env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$1" 2>/dev/null; }
has() { if detect "$1" | grep -qxF -- "$2"; then assert_equals "y" "y" "$3"; else assert_equals "y" "n" "$3"; fi; }
lacks() { if detect "$1" | grep -qxF -- "$2"; then assert_equals "n" "y" "$3"; else assert_equals "n" "n" "$3"; fi; }

echo ""
echo "=== AC-1 non-matching Detect is quiet ==="
ws="$(new_ws)"
printf '# M\n\n**Detect:** exists nothing-here | contains nope.txt zzz\n' > "$ws/ravintio-zero/migrations/0101-a.md"
lacks "$ws" "pending migration: 0101" "no match, no ledger row: quiet"

echo ""
echo "=== AC-2 matching Detect prints ==="
ws="$(new_ws)"; mkdir -p "$ws/there"
printf '# M\n\n**Detect:** exists nothing-here | exists there\n' > "$ws/ravintio-zero/migrations/0102-a.md"
has "$ws" "pending migration: 0102" "one true item: prints"

echo ""
echo "=== AC-3 no Detect line prints ==="
ws="$(new_ws)"
printf '# M\n\nNo detect line.\n' > "$ws/ravintio-zero/migrations/0103-a.md"
has "$ws" "pending migration: 0103" "no Detect line: prints"

echo ""
echo "=== done row still wins ==="
ws="$(new_ws)"; mkdir -p "$ws/there"
printf '# M\n\n**Detect:** exists there\n' > "$ws/ravintio-zero/migrations/0104-a.md"
printf '| 0104 | done | 1.0.0 |\n' > "$ws/plan/state/migrations.md"
lacks "$ws" "pending migration: 0104" "done row with true Detect: quiet"

echo ""
echo "=== real migrations in a bare project ==="
ws="$(new_ws)"; mkdir -p "$ws/plan/_archive"
cp "$REAL_MIG"/0004-*.md "$REAL_MIG"/0005-*.md "$REAL_MIG"/0008-*.md "$REAL_MIG"/0009-*.md "$ws/ravintio-zero/migrations/"
lacks "$ws" "pending migration: 0004" "0004 quiet"
lacks "$ws" "pending migration: 0005" "0005 quiet"
lacks "$ws" "pending migration: 0008" "0008 quiet"
has "$ws" "pending migration: 0009" "0009 prints with plan/_archive"

print_summary
