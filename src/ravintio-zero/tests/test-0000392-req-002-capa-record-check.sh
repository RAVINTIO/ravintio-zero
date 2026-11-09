#!/usr/bin/env bash
# Tests for feature 0000392-ship-postmortems, req-002: the CAPA record check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/postmortem-check.mjs"
TEMPLATE="$SCRIPT_DIR/../templates/postmortem.template.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# record NAME CORRECTIVE_ROW PREVENTIVE_ROW DETECTIVE_ROW
record() {
  local f="$WORK/$1.md"
  {
    printf '# Postmortem\n\n## Summary\n\nx\n\n## Actions\n\n'
    printf '| Type | Action | Status | Owner | Lives in | Verified by | Ref |\n'
    printf '|------|--------|--------|-------|----------|-------------|-----|\n'
    [ -n "$2" ] && printf '%s\n' "$2"
    [ -n "$3" ] && printf '%s\n' "$3"
    [ -n "$4" ] && printf '%s\n' "$4"
  } > "$f"
  echo "$f"
}

C='| corrective | Fix the title | done | me | src | test | PR #12 |'
P='| preventive | Add a check | filed | me | src | test | backlog entry 0000403 |'
D='| detective | none, because the CI job already catches it | none | | | | |'

echo ""
echo "=== req-002 AC-1: a missing type fails ==="
OUT=$(node "$TOOL" "$(record missing "$C" "" "$D")" 2>&1); RC=$?
assert_equals "1" "$RC" "req-002 AC-1: exit 1 without a preventive row"
assert_contains "no preventive row" "$OUT" "req-002 AC-1: the finding names preventive"

echo ""
echo "=== req-002 AC-2: a none-because row passes ==="
OUT=$(node "$TOOL" "$(record ok "$C" "$P" "$D")" 2>&1); RC=$?
assert_equals "0" "$RC" "req-002 AC-2: exit 0 with all three types"
assert_contains "clean" "$OUT" "req-002 AC-2: the check reports clean"
OUT=$(node "$TOOL" "$(record nobecause "$C" "$P" '| detective | none | none | | | | |')" 2>&1); RC=$?
assert_equals "1" "$RC" "req-002 AC-2: a bare none fails"

echo ""
echo "=== req-002 AC-3: a done row needs a reference ==="
OUT=$(node "$TOOL" "$(record noref '| corrective | Fix the title | done | me | src | test | |' "$P" "$D")" 2>&1); RC=$?
assert_equals "1" "$RC" "req-002 AC-3: exit 1 for a done row with no Ref"
assert_contains "corrective row is done and has no Ref" "$OUT" "req-002 AC-3: the finding names the row"

echo ""
echo "=== req-002: the template ==="
TPL=$(cat "$TEMPLATE")
assert_contains "| Type | Action | Status | Owner | Lives in | Verified by | Ref |" "$TPL" "req-002: the template has the CAPA columns"
assert_contains "none, because" "$TPL" "req-002: the template shows the none-because form"
assert_contains "postmortem-check.mjs" "$TPL" "req-002: the template names the check"

print_summary
