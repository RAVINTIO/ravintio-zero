#!/usr/bin/env bash
# Tests for feature 0000321 REQ-004: the --review mode of the backlog index script.
# AC-1: review lists an entry older than the review age and not a newer one.
# AC-2: backlogReviewDays in product.yml sets the age.
# Also: undated entries are listed and review writes nothing.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

GEN="$ZERO_DIR/scripts/backlog-index.mjs"
TODAY="2026-11-01"

WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# add_entry REPO ID-SLUG DATE: DATE may be empty for an undated entry.
add_entry() {
  local repo="$1" dir="$2" date="$3"
  mkdir -p "$repo/plan/backlog/$dir"
  {
    printf -- '---\ntitle: "Backlog Entry: x - t"\nstatus: "open"\n---\n# t\n\n'
    [ -n "$date" ] && echo "**Date filed:** $date"
    echo "Body"
  } > "$repo/plan/backlog/$dir/entry.md"
}
make_repo() {
  mkdir -p "$WS/$1/plan/backlog"
  add_entry "$WS/$1" 0000050-old 2026-10-26
  add_entry "$WS/$1" 0000051-new 2026-10-30
  echo "$WS/$1"
}
review() { local r="$1"; shift; node "$GEN" --root "$r" --review --today "$TODAY" "$@" 2>"$WS/stderr"; }

if [ ! -f "$GEN" ]; then
  echo "  FAIL: script missing: $GEN"
  FAIL=$((FAIL + 1))
  print_summary
fi

echo "=== AC-1: review lists a stale entry ==="
R=$(make_repo ac1)
OUT=$(review "$R"); CODE=$?
assert_equals "0" "$CODE" "exits 0"
assert_contains "backlog-review: 1 entries older than 5 days" "$OUT" "header with default age"
assert_contains "0000050-old 6 days" "$OUT" "6-day-old entry listed"
assert_not_contains "0000051-new" "$OUT" "2-day-old entry not listed"
assert_equals "backlog-review: 1 entries older than 5 days" "$(printf '%s\n' "$OUT" | head -n 1)" "header comes first"
assert_equals "no" "$([ -e "$R/plan/backlog/index.md" ] && echo yes || echo no)" "review writes no index"

echo "=== AC-2: age comes from product.yml ==="
R=$(make_repo ac2)
printf 'name: x\nbacklogReviewDays: 10\n' > "$R/product.yml"
OUT=$(review "$R"); CODE=$?
assert_equals "0" "$CODE" "exits 0"
assert_equals "backlog-review: 0 entries older than 10 days" "$OUT" "lists nothing at 10 days"
printf 'backlogReviewDays: 1\n' > "$R/product.yml"
OUT=$(review "$R")
assert_contains "0000051-new 2 days" "$OUT" "age 1 lists the newer entry too"
for bad in 0 -3 abc 2.5; do
  printf 'backlogReviewDays: %s\n' "$bad" > "$R/product.yml"
  OUT=$(review "$R")
  assert_contains "older than 5 days" "$OUT" "value '$bad' reads as 5"
done

echo "=== Undated entry and ordering ==="
R=$(make_repo undated)
add_entry "$R" 0000049-nodate ""
OUT=$(review "$R")
assert_contains "0000049-nodate undated" "$OUT" "undated entry listed"
assert_equals "backlog-review: 2 entries older than 5 days" "$(printf '%s\n' "$OUT" | head -n 1)" "undated counted in header"
assert_equals "0000049-nodate undated" "$(printf '%s\n' "$OUT" | sed -n 2p)" "ordered by id"

echo "=== Malformed entry still fails ==="
R=$(make_repo malformed)
mkdir -p "$R/plan/backlog/0000052-bad"; echo "nope" > "$R/plan/backlog/0000052-bad/entry.md"
review "$R" >/dev/null; CODE=$?
assert_equals "1" "$CODE" "exits 1"
assert_contains "check: malformed entry 0000052-bad:" "$(cat "$WS/stderr")" "names the entry"

print_summary
