#!/usr/bin/env bash
# Tests for feature 0000320 REQ-003: the migration ledger.
# AC-1: a ledger done row keeps resume-detect.mjs quiet about a pending migration.
# AC-2: the migrator skill appends to the ledger and leaves the pack unchanged.
# AC-3: the 0006 helper copies _done/ records into the ledger, once.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$ZERO_DIR/migrations/migrate-migration-ledger.sh"
SKILL="$ZERO_DIR/skills/ravintio-migrator/SKILL.md"
DETECT="${RESUME_DETECT:-$ZERO_DIR/scripts/resume-detect.mjs}"

WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# make_repo NAME: scratch consumer repo with a pack, a _done/ folder and a version.
make_repo() {
  local d="$WS/$1"
  mkdir -p "$d/ravintio-zero/migrations/_done"
  printf 'name: ravintio-zero\nversion: "1.2.3"\n' > "$d/ravintio-zero/component.yml"
  echo "m" > "$d/ravintio-zero/migrations/_done/0001-date-format.md"
  echo "m" > "$d/ravintio-zero/migrations/_done/0002-british-english.md"
  echo "m" > "$d/ravintio-zero/migrations/_done/retroactive-release-tags.md"
  : > "$d/ravintio-zero/migrations/_done/.gitkeep"
  echo "$d"
}
run() { ( cd "$1" && bash "$HELPER" 2>&1 ); }
snapshot() { ( cd "$1" && find . -print | LC_ALL=C sort ); }

echo "=== AC-3: helper copies _done/ records ==="
if [ -f "$HELPER" ]; then
  R=$(make_repo fresh)
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "helper exits 0"
  L="$R/plan/state/migrations.md"
  assert_equals "yes" "$([ -f "$L" ] && echo yes || echo no)" "helper creates plan/state/migrations.md"
  assert_equals "1" "$(grep -c '^| Migration | Result | Pack version |$' "$L")" "ledger has the table header"
  assert_equals "1" "$(grep -cxF '| 0001 | done | 1.2.3 |' "$L")" "0001 row is done at the pack version"
  assert_equals "1" "$(grep -cxF '| 0002 | done | 1.2.3 |' "$L")" "0002 row is done"
  assert_equals "1" "$(grep -cxF '| retroactive-release-tags | done | 1.2.3 |' "$L")" "unnumbered file uses its stem"
  assert_equals "3" "$(grep -c '| done |' "$L")" "one done row per file"
  assert_equals "3" "$(ls "$R/ravintio-zero/migrations/_done" | wc -l | tr -d ' ')" "helper deletes nothing from _done/"
  BEFORE=$(cat "$L")
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "rerun exits 0"
  assert_equals "$BEFORE" "$(cat "$L")" "rerun adds no duplicate"

  R=$(make_repo existing)
  mkdir -p "$R/plan/state"
  printf 'Header text.\n\n| Migration | Result | Pack version |\n|---|---|---|\n| 0004 | not applicable | 1.0.0 |\n| 0001 | done | 0.9.0 |' > "$R/plan/state/migrations.md"
  OUT=$(run "$R"); CODE=$?
  L="$R/plan/state/migrations.md"
  assert_equals "0" "$CODE" "existing ledger exits 0"
  assert_equals "1" "$(grep -c '^| 0001 |' "$L")" "existing 0001 row not duplicated"
  assert_equals "1" "$(grep -c '^| 0004 | not applicable | 1.0.0 |$' "$L")" "existing rows kept"
  assert_equals "1" "$(grep -cxF '| 0002 | done | 1.2.3 |' "$L")" "new row starts on its own line"

  R=$(make_repo symlink)
  mkdir -p "$R/plan" "$WS/elsewhere"
  ln -s "$WS/elsewhere" "$R/plan/state"
  BEFORE=$(snapshot "$WS/elsewhere")
  OUT=$(run "$R"); CODE=$?
  assert_equals "1" "$CODE" "symlinked plan/state exits 1"
  assert_equals "$BEFORE" "$(snapshot "$WS/elsewhere")" "nothing written through the link"

  R=$(make_repo none)
  rm -rf "$R/ravintio-zero/migrations/_done"
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "no _done/ folder exits 0"
else
  assert_equals "exists" "missing" "migrate-migration-ledger.sh exists"
fi
assert_equals "yes" "$([ -f "$ZERO_DIR/migrations/migrate-migration-ledger.ps1" ] && echo yes || echo no)" "ps1 helper exists"
assert_equals "yes" "$([ -f "$ZERO_DIR/migrations/0006-migration-ledger.md" ] && echo yes || echo no)" "migration 0006 exists"
assert_contains "**Detect:** exists ravintio-zero/migrations/_done" "$(cat "$ZERO_DIR/migrations/0006-migration-ledger.md" 2>/dev/null)" "0006 carries a Detect line"

echo "=== AC-2: migrator skill text ==="
MIG=$(cat "$SKILL")
assert_contains "plan/state/migrations.md" "$MIG" "skill names the ledger"
assert_contains "not applicable" "$MIG" "skill records not applicable"
assert_contains "pack version" "$MIG" "skill records the pack version"
assert_contains "edits nothing in \`ravintio-zero/\`" "$MIG" "skill edits nothing in the pack"
assert_contains "does not move files into \`_done/\`" "$MIG" "skill no longer archives into _done/"
assert_not_contains "Move the migration file" "$MIG" "skill has no move step"

echo "=== AC-1: a done row keeps resume-detect quiet ==="
R=$(make_repo detect)
echo "m" > "$R/ravintio-zero/migrations/0006-example.md"
OUT=$(node "$DETECT" "$R" 2>/dev/null)
assert_contains "pending migration: 0006" "$OUT" "pending migration reported without a ledger row"
mkdir -p "$R/plan/state"
printf '| Migration | Result | Pack version |\n|---|---|---|\n| 0006 | done | 1.2.3 |\n' > "$R/plan/state/migrations.md"
OUT=$(node "$DETECT" "$R" 2>/dev/null)
assert_not_contains "pending migration: 0006" "$OUT" "done row keeps the finding quiet"

print_summary
