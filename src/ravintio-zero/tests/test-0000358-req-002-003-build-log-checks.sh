#!/usr/bin/env bash
# Test: 0000358 req-002 and req-003 build-log-checks
# build-log-check.mjs fails a logged time later than the commit that adds it,
# and fails a closed phase block with no Complete: line.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
CHECK="$ZERO_DIR/scripts/build-log-check.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# block <n> <name> <start> <end> <wall> <complete>: one phase block.
# <complete> is yes to add a Complete: line.
block() {
  printf '### P%s: %s\n\n| Field | Value |\n|-------|-------|\n| Start | `%s` |\n| End | `%s` |\n| Wall clock | `%s` |\n| Model tier | primary |\n\n' "$1" "$2" "$3" "$4" "$5"
  if [ "$6" = yes ]; then printf 'Complete: P%s (%s)\n\n' "$1" "$4"; fi
}
summary() {
  printf '## Summary\n\n| Metric | Value |\n|--------|-------|\n| Total phases completed | `5` |\n| Total wall clock | `%s` |\n' "$1"
}
# log <file> <p1-complete> <base-day>: five filled blocks.
log() {
  local d="$3"
  {
    printf '# Build Log\n\n## Phase Log\n\n'
    block 0 Discovery "${d}T12:00:00Z" "${d}T12:03:00Z" 3 yes
    block 1 Plan "${d}T12:03:00Z" "${d}T12:10:00Z" 7 "$2"
    block 2 Implement "${d}T12:10:00Z" "${d}T12:30:00Z" 20 yes
    block 3 "Validate and Accept" "${d}T12:30:00Z" "${d}T12:40:00Z" 10 yes
    block 4 Ship "${d}T12:40:00Z" "${d}T12:45:00Z" 5 yes
    summary 45
  } > "$1"
}
run_check() { OUT=$(node "$CHECK" "$1" 2>&1); CODE=$?; }

echo ""
echo "=== req-003 AC-1: a closed block with no Complete line fails ==="
log "$TMP/open.md" no 2026-10-28
run_check "$TMP/open.md"
assert_equals "1" "$CODE" "req-003 AC-1: P1 with End filled and no Complete line fails"
assert_contains "P1" "$OUT" "req-003 AC-1: the finding names P1"
assert_contains "Complete" "$OUT" "req-003 AC-1: the finding names the Complete line"

echo ""
echo "=== req-003 AC-2: a complete log passes ==="
log "$TMP/full.md" yes 2026-10-28
run_check "$TMP/full.md"
assert_equals "0" "$CODE" "req-003 AC-2: every closed block holds a Complete line"

echo ""
echo "=== req-003 AC-3: a running phase passes ==="
{
  printf '# Build Log\n\n## Phase Log\n\n'
  block 0 Discovery 2026-10-28T12:00:00Z 2026-10-28T12:03:00Z 3 yes
  printf '### P1: Plan\n\n| Field | Value |\n|-------|-------|\n| Start | `2026-10-28T12:03:00Z` |\n| End | `{{pending}}` |\n| Wall clock | `{{pending}}` |\n\n'
} > "$TMP/running.md"
run_check "$TMP/running.md"
assert_not_contains "P1: no Complete" "$OUT" "req-003 AC-3: a running P1 has no Complete finding"

echo ""
echo "=== req-003: a Skipped line excuses a block with no Complete line ==="
{ cat "$TMP/open.md"; printf '\nSkipped: P1 (chart row)\n'; } > "$TMP/open-skipped.md"
run_check "$TMP/open-skipped.md"
assert_equals "0" "$CODE" "req-003: a Skipped: P1 line passes"

echo ""
echo "=== req-002 AC-2: a time later than its commit fails ==="
R="$TMP/repo"
mkdir -p "$R"
git -C "$R" init -q
log "$R/build-log.md" yes 2026-10-28
git -C "$R" stage build-log.md
GIT_COMMITTER_DATE="2026-10-28T12:50:00Z" GIT_AUTHOR_DATE="2026-10-28T12:50:00Z" \
  git -C "$R" -c user.name=t -c user.email=t@example.com commit -qm base
run_check "$R/build-log.md"
assert_equals "0" "$CODE" "req-002 AC-3: times at or before the commit pass"

sed 's/^| End | `2026-10-28T12:45:00Z` |/| End | `2026-10-28T13:45:00Z` |/; s/^| Wall clock | `5` |/| Wall clock | `65` |/; s/^Complete: P4 (2026-10-28T12:45:00Z)/Complete: P4 (2026-10-28T13:45:00Z)/' \
  "$R/build-log.md" > "$R/next.md"
cp "$R/next.md" "$R/build-log.md"
git -C "$R" stage build-log.md
GIT_COMMITTER_DATE="2026-10-28T12:55:00Z" GIT_AUTHOR_DATE="2026-10-28T12:55:00Z" \
  git -C "$R" -c user.name=t -c user.email=t@example.com commit -qm later
run_check "$R/build-log.md"
assert_equals "1" "$CODE" "req-002 AC-2: an End an hour after its commit fails"
assert_contains "P4" "$OUT" "req-002 AC-2: the finding names the phase"
assert_contains "later than" "$OUT" "req-002 AC-2: the finding says the time is later than the commit"

echo ""
echo "=== req-002: an uncommitted time is compared with the clock ==="
log "$TMP/future.md" yes 2099-01-01
run_check "$TMP/future.md"
assert_equals "1" "$CODE" "req-002: a time in 2099 in an untracked log fails"
assert_contains "later than" "$OUT" "req-002: the finding says the time is later than the clock"

print_summary
