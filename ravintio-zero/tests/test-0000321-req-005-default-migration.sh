#!/usr/bin/env bash
# Tests for feature 0000321 REQ-005: migration 0007 sets default priority and theme.
# AC-1: the helper adds the missing fields and changes no other line.
# AC-2: the helper is idempotent.
# Also: an existing priority is kept, no-frontmatter entries and symlinks are skipped.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$ZERO_DIR/migrations/migrate-backlog-priority-and-theme.sh"
MIGRATION="$ZERO_DIR/migrations/0007-backlog-priority-and-theme.md"

WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# make_repo NAME: scratch consumer repo with three backlog entries.
make_repo() {
  local d="$WS/$1"
  mkdir -p "$d/plan/backlog/0000001-a" "$d/plan/backlog/0000002-b" "$d/plan/backlog/0000003-c"
  printf -- '---\ntitle: "Backlog Entry: 1"\nstatus: "open"\n---\n# One\n\nBody line.\n' > "$d/plan/backlog/0000001-a/entry.md"
  printf -- '---\ntitle: "Backlog Entry: 2"\npriority: "high"\nstatus: "open"\n---\n# Two\n\n---\nnot frontmatter\n' > "$d/plan/backlog/0000002-b/entry.md"
  printf -- '# Three\n\nNo frontmatter here.\n' > "$d/plan/backlog/0000003-c/entry.md"
  echo "$d"
}
run() { ( cd "$1" && bash "$HELPER" 2>&1 ); }
snapshot() { ( cd "$1" && find . -type f -exec cksum {} + | LC_ALL=C sort ); }

echo "=== files exist ==="
assert_equals "yes" "$([ -f "$HELPER" ] && echo yes || echo no)" "bash helper exists"
assert_equals "yes" "$([ -f "$ZERO_DIR/migrations/migrate-backlog-priority-and-theme.ps1" ] && echo yes || echo no)" "ps1 helper exists"
assert_equals "yes" "$([ -f "$MIGRATION" ] && echo yes || echo no)" "migration 0007 exists"
M=$(cat "$MIGRATION" 2>/dev/null)
assert_contains "**Detect:** exists plan/backlog" "$M" "0007 carries a Detect line"
assert_contains "**Applies when:**" "$M" "0007 carries an Applies when line"
assert_contains "**Safe to skip:** Yes" "$M" "0007 is safe to skip"
assert_contains "Proceed? (y/n)" "$M" "0007 asks for confirmation"
assert_contains "migrate-backlog-priority-and-theme.sh" "$M" "0007 names the bash helper"
assert_contains "migrate-backlog-priority-and-theme.ps1" "$M" "0007 names the ps1 helper"

if [ -f "$HELPER" ]; then
  echo "=== AC-1: helper adds missing fields ==="
  R=$(make_repo fresh)
  A="$R/plan/backlog/0000001-a/entry.md"
  B="$R/plan/backlog/0000002-b/entry.md"
  C="$R/plan/backlog/0000003-c/entry.md"
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "helper exits 0"
  EXPECT_A=$(printf -- '---\ntitle: "Backlog Entry: 1"\nstatus: "open"\npriority: "medium"\ntheme: "unsorted"\n---\n# One\n\nBody line.\n')
  assert_equals "$EXPECT_A" "$(cat "$A")" "entry 1 gains both fields before the closing rule only"
  EXPECT_B=$(printf -- '---\ntitle: "Backlog Entry: 2"\npriority: "high"\nstatus: "open"\ntheme: "unsorted"\n---\n# Two\n\n---\nnot frontmatter\n')
  assert_equals "$EXPECT_B" "$(cat "$B")" "entry 2 keeps priority high and gains theme"
  assert_equals "$(printf -- '# Three\n\nNo frontmatter here.\n')" "$(cat "$C")" "entry without frontmatter is unchanged"

  echo "=== AC-2: helper is idempotent ==="
  BEFORE=$(snapshot "$R")
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "rerun exits 0"
  assert_equals "$BEFORE" "$(snapshot "$R")" "rerun changes no file"

  echo "=== symlinked entry is skipped ==="
  R=$(make_repo linked)
  mkdir -p "$WS/target" "$R/plan/backlog/0000004-d"
  printf -- '---\ntitle: "T"\n---\nBody\n' > "$WS/target/entry.md"
  ln -s "$WS/target/entry.md" "$R/plan/backlog/0000004-d/entry.md"
  BEFORE=$(cksum < "$WS/target/entry.md")
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "helper exits 0 with a symlinked entry"
  assert_equals "$BEFORE" "$(cksum < "$WS/target/entry.md")" "link target is unchanged"

  echo "=== symlinked plan/backlog is refused ==="
  R="$WS/badlink"
  mkdir -p "$R/plan" "$WS/elsewhere/0000009-x"
  printf -- '---\ntitle: "T"\n---\nBody\n' > "$WS/elsewhere/0000009-x/entry.md"
  ln -s "$WS/elsewhere" "$R/plan/backlog"
  BEFORE=$(snapshot "$WS/elsewhere")
  OUT=$(run "$R"); CODE=$?
  assert_equals "1" "$CODE" "symlinked plan/backlog exits 1"
  assert_equals "$BEFORE" "$(snapshot "$WS/elsewhere")" "nothing written through the link"

  echo "=== symlinked plan is refused ==="
  R="$WS/badplan"
  mkdir -p "$R" "$WS/elsewhere2/backlog/0000009-x"
  printf -- '---\ntitle: "T"\n---\nBody\n' > "$WS/elsewhere2/backlog/0000009-x/entry.md"
  ln -s "$WS/elsewhere2" "$R/plan"
  BEFORE=$(snapshot "$WS/elsewhere2")
  OUT=$(run "$R"); CODE=$?
  assert_equals "1" "$CODE" "symlinked plan exits 1"
  assert_equals "$BEFORE" "$(snapshot "$WS/elsewhere2")" "nothing written through the plan link"

  echo "=== missing plan/backlog ==="
  R="$WS/nobacklog"; mkdir -p "$R"
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "no plan/backlog exits 0"

  echo "=== index script runs only when present ==="
  R=$(make_repo indexed)
  mkdir -p "$R/ravintio-zero/scripts"
  echo 'import fs from "node:fs"; fs.writeFileSync("ran.txt","ok")' > "$R/ravintio-zero/scripts/backlog-index.mjs"
  OUT=$(run "$R"); CODE=$?
  assert_equals "0" "$CODE" "exits 0 when the index script succeeds"
  assert_equals "ok" "$(cat "$R/ran.txt" 2>/dev/null)" "index script ran from the project root"
  echo 'process.exit(3)' > "$R/ravintio-zero/scripts/backlog-index.mjs"
  OUT=$(run "$R"); CODE=$?
  assert_equals "1" "$CODE" "exits non-zero when the index script fails"
fi

print_summary
