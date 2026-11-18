#!/usr/bin/env bash
# Tests for feature 0000560 REQ-001: resume-detect.mjs ledger rows beside a Detect line.
# A done row stays quiet. A not applicable row reports when its Detect line is true.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPT="${RESUME_DETECT:-$SCRIPT_DIR/../scripts/resume-detect.mjs}"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

# new_ws MIGRATION_ID DETECT_ITEM ROW: a project at pack version 2.0.0 with one migration and one ledger row.
new_ws() {
  local w
  w="$(mktemp -d "$TMP_ROOT/ws.XXXXXX")"
  mkdir -p "$w/ravintio-zero/migrations" "$w/plan/state" "$w/there"
  printf 'version: "2.0.0"\n' > "$w/ravintio-zero/component.yml"
  printf '# M\n\n**Detect:** %s\n' "$2" > "$w/ravintio-zero/migrations/$1-a.md"
  printf '%s\n' "$3" > "$w/plan/state/migrations.md"
  echo "$w"
}
detect() { env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$1" 2>/dev/null; }
has() { if detect "$1" | grep -qxF -- "$2"; then assert_equals "y" "y" "$3"; else assert_equals "y" "n" "$3"; fi; }
lacks() { if detect "$1" | grep -qxF -- "$2"; then assert_equals "n" "y" "$3"; else assert_equals "n" "n" "$3"; fi; }

echo ""
echo "=== AC-1 a done row stays quiet ==="
ws="$(new_ws 0201 "exists there" "| 0201 | done | 1.0.0 |")"
lacks "$ws" "pending migration: 0201" "done row, true Detect: quiet"

echo ""
echo "=== AC-2 a not applicable row with a true Detect line reports ==="
ws="$(new_ws 0202 "exists there" "| 0202 | not applicable | 2.0.0 |")"
has "$ws" "pending migration: 0202" "current version, true Detect: pending"
ws="$(new_ws 0203 "exists there" "| 0203 | not applicable | 1.0.0 |")"
has "$ws" "pending migration: 0203" "older version, true Detect: pending"

echo ""
echo "=== AC-3 a not applicable row with a false Detect line stays quiet ==="
ws="$(new_ws 0204 "exists nothing-here" "| 0204 | not applicable | 2.0.0 |")"
lacks "$ws" "pending migration: 0204" "current version, false Detect: quiet"

print_summary
