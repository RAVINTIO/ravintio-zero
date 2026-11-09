#!/usr/bin/env bash
# Tests for feature 0000321 REQ-005 AC-3: this repo is migrated.
# AC-3: every backlog entry holds priority and theme, the ledger holds a 0007 row, and the index is current.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO="$(cd "$ZERO_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

echo "=== AC-3: this repo is migrated ==="
MISSING=0
COUNT=0
for f in "$REPO"/plan/backlog/*/entry.md; do
  [ -f "$f" ] || continue
  COUNT=$((COUNT + 1))
  FM=$(awk 'NR==1 && $0=="---"{n=1; next} n==1 && $0=="---"{exit} n==1{print}' "$f")
  printf '%s\n' "$FM" | grep -q '^priority:' || MISSING=$((MISSING + 1))
  printf '%s\n' "$FM" | grep -q '^theme:' || MISSING=$((MISSING + 1))
done
assert_equals "yes" "$([ "$COUNT" -gt 0 ] && echo yes || echo no)" "the backlog holds entries"
assert_equals "0" "$MISSING" "every entry holds priority and theme"
assert_equals "1" "$(grep -c '^| 0007 | done |' "$REPO/plan/state/migrations.md")" "the ledger holds one 0007 done row"
node "$ZERO_DIR/scripts/backlog-index.mjs" --root "$REPO" --check >/dev/null 2>&1
assert_equals "0" "$?" "the committed index matches a fresh run"

print_summary
