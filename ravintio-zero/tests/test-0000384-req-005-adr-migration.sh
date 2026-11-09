#!/usr/bin/env bash
# Tests for feature 0000384-plan-checks, req-005: migration 0009 moves archived ADRs
# into docs/adr under unique four-digit numbers, rebuilds the index, and is idempotent.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MIG="$ZERO_DIR/migrations/migrate-adr-home.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

adr_text() { # title status supersedes feature-dir
  printf -- '---\ntitle: "ADR 001: %s"\nsummary: "Summary of %s."\nstatus: "%s"\nversion: "0.1.0"\n---\n# ADR-001 - %s\n\n**Feature:** %s\n\nSee ADR-002 here.\n\n## Supersedes\n\n%s\n\n## Superseded By\n\n- None\n' \
    "$1" "$1" "$2" "$1" "$4" "$3"
}

# Commit everything in the fixture. A subshell keeps the git calls on literal paths.
commit_all() { (cd "$1" && git add . && git commit -qm "$2"); }

make_fixture() {
  local ws="$1"
  mkdir -p "$ws"
  git init -q "$ws"
  git -C "$ws" config user.email t@example.com
  git -C "$ws" config user.name t
  printf 'id: "demo-product"\n' >"$ws/product.yml"
  mkdir -p "$ws/docs" "$ws/plan/_archive/0000001-old-feature/adr" "$ws/plan/_archive/0000030-first-2026-08-22/adr" "$ws/plan/_archive/0000031-second-2026-08-30/adr"
  printf '# Decisions Index\n\nLast updated: x\n\n## All Architecture Decision Records\n### Feature 0000030: old\n' >"$ws/docs/decisions-index.md"
  adr_text "Old choice" accepted "- None" 0000001-old-feature >"$ws/plan/_archive/0000001-old-feature/adr/ADR-001-old-choice.md"
  adr_text "Old second" accepted "- ADR-001" 0000001-old-feature >"$ws/plan/_archive/0000001-old-feature/adr/ADR-002-old-second.md"
  commit_all "$ws" "add old"
  git -C "$ws" rm -qr plan/_archive/0000001-old-feature
  git -C "$ws" commit -qm "remove old"
  adr_text "Stack choice" accepted "- None" 0000030-first >"$ws/plan/_archive/0000030-first-2026-08-22/adr/ADR-001-stack-choice.md"
  adr_text "Second thing" accepted "- None" 0000030-first >"$ws/plan/_archive/0000030-first-2026-08-22/adr/ADR-002-second-thing.md"
  adr_text "Stack choice" accepted "- 0000030 ADR-002" 0000031-second >"$ws/plan/_archive/0000031-second-2026-08-30/adr/ADR-001-stack-choice.md"
  adr_text "Replacement" accepted "- 0000001 ADR-002 and 0000030 ADR-001" 0000031-second >"$ws/plan/_archive/0000031-second-2026-08-30/adr/ADR-002-replacement.md"
  commit_all "$ws" "add archive"
}

has() { assert_contains "$2" "$1" "$3"; }
snapshot() { (cd "$1" && find . -path ./.git -prune -o -type f -print | sort | xargs shasum); }

WS="$TMP/ws"
make_fixture "$WS"

echo ""
echo "=== req-005: dry run writes nothing ==="
before="$(snapshot "$WS")"
bash "$MIG" --root "$WS" --dry-run >"$TMP/dry.out" 2>&1
assert_equals "$before" "$(snapshot "$WS")" "--dry-run leaves every file unchanged"

echo ""
echo "=== req-005 AC-1: unique four-digit names, no archived ADR left ==="
bash "$MIG" --root "$WS" >"$TMP/run1.out" 2>&1
assert_equals 0 "$?" "first run exits 0"
names="$(ls "$WS/docs/adr" | grep -E '^[0-9]{4}-.*\.md$' | sort)"
assert_equals 6 "$(printf '%s\n' "$names" | wc -l | tr -d ' ')" "six ADR files in docs/adr"
assert_equals 6 "$(printf '%s\n' "$names" | cut -c1-4 | sort | uniq | wc -l | tr -d ' ')" "numbers are unique"
assert_equals "0001-old-choice.md" "$(printf '%s\n' "$names" | sed -n 1p)" "restored feature 0000001 numbers first"
assert_equals "0003-stack-choice.md" "$(printf '%s\n' "$names" | sed -n 3p)" "feature order then ADR order"
left="$(find "$WS/plan/_archive" -name 'ADR-*.md' | wc -l | tr -d ' ')"
assert_equals 0 "$left" "no archived ADR file remains"
readme="$(cat "$WS/plan/_archive/0000030-first-2026-08-22/adr/README.md")"
assert_equals "ADRs moved to docs/adr/. See 0003-stack-choice.md, 0004-second-thing.md." "$readme" "link file lists the new files"
has "$(cat "$WS/docs/adr/0003-stack-choice.md")" 'component: "demo-product"' "component added from product.yml"
has "$(cat "$WS/docs/adr/0003-stack-choice.md")" 'feature: "0000030-first"' "feature field added"
has "$(cat "$WS/docs/adr/0003-stack-choice.md")" 'status: "accepted"' "status kept"

echo ""
echo "=== req-005: references resolve ==="
has "$(cat "$WS/docs/adr/0003-stack-choice.md")" "See ADR-0004 here." "same-feature reference rewritten"
has "$(cat "$WS/docs/adr/0006-replacement.md")" "ADR-0002 and ADR-0003" "cross-feature references rewritten"
has "$(cat "$WS/docs/adr/0005-stack-choice.md")" "- ADR-0004" "Supersedes form rewritten"
bad=0
for f in "$WS"/docs/adr/[0-9]*.md; do
  for n in $(grep -iE 'supersede|^- ADR-' "$f" | grep -oE 'ADR-[0-9]{4}' | cut -c5-); do
    ls "$WS"/docs/adr/"$n"-*.md >/dev/null 2>&1 || bad=$((bad + 1))
  done
done
assert_equals 0 "$bad" "every reference names an existing number"
has "$(cat "$WS/docs/adr/.migration-map.json")" '"0000030:001"' "map file written"

echo ""
echo "=== req-005 AC-2: index row per file and file per row ==="
idx="$(cat "$WS/docs/decisions-index.md")"
has "$idx" "Last updated: x" "index header kept"
rows="$(grep -cE '^\| \[ADR-[0-9]{4}\]' "$WS/docs/decisions-index.md")"
assert_equals 6 "$rows" "one row per ADR file"
missing=0
for p in $(grep -oE '\(adr/[^)]+\)' "$WS/docs/decisions-index.md" | tr -d '()'); do
  [ -f "$WS/docs/$p" ] || missing=$((missing + 1))
done
assert_equals 0 "$missing" "every row points at an existing file"
assert_equals "0007" "$(cat "$WS/docs/adr/.next-id")" ".next-id is highest plus one"

echo ""
echo "=== req-005 AC-3: second run changes nothing ==="
before="$(snapshot "$WS")"
bash "$MIG" --root "$WS" >"$TMP/run2.out" 2>&1
assert_equals 0 "$?" "second run exits 0"
assert_equals "$before" "$(snapshot "$WS")" "second run changes zero files"

echo ""
echo "=== req-005: a broken reference exits 1 ==="
WS2="$TMP/ws2"
make_fixture "$WS2"
printf -- '---\ntitle: "ADR 003: Bad"\nstatus: "accepted"\n---\n# ADR-003 - Bad\n\n## Supersedes\n\n- ADR-0099\n' \
  >"$WS2/plan/_archive/0000030-first-2026-08-22/adr/ADR-003-bad.md"
bash "$MIG" --root "$WS2" --no-restore >"$TMP/bad.out" 2>"$TMP/bad.err"
assert_equals 1 "$?" "a reference to a missing number exits 1"
has "$(cat "$TMP/bad.err")" "ADR-0099" "the broken reference is listed"

print_summary
