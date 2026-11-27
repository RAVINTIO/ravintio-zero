#!/usr/bin/env bash
# Test: 0000576 req-001 start-time-check
# build-log-check.mjs check 10 fails a phase block whose Start is later than
# the first commit of that phase's artifacts.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
CHECK="$ZERO_DIR/scripts/build-log-check.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# commit <repo> <iso time> <message>: commit every change at a fixed time.
commit() {
  (cd "$1" && git add -A && GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" git commit -q -m "$3")
}
# log <file> <p1-start> <wall>: a build log with one P1 block.
log() {
  printf '# Build Log\n\n## Phase Log\n\n### P1: Plan\n\n| Field | Value |\n|-------|-------|\n| Start | `%s` |\n| End | `2026-11-10T12:30:00Z` |\n| Wall clock | `%s` |\n\nComplete: P1 (2026-11-10T12:30:00Z)\n' "$2" "$3" > "$1"
}
# world <name> <p1-start> <wall> <add-artifact>: a repo with the log added at 12:00.
world() {
  local r="$TMP/$1"
  mkdir -p "$r/plan/current"
  git -C "$r" init -q
  git -C "$r" config user.email t@example.com
  git -C "$r" config user.name t
  log "$r/plan/current/build-log.md" "$2" "$3"
  commit "$r" 2026-11-10T12:00:00Z "add the log"
  if [ "$4" = yes ]; then
    printf 'scope\n' > "$r/plan/current/scope.md"
    commit "$r" 2026-11-10T12:02:00Z "add the scope"
  fi
}
run_check() { OUT=$(node "$CHECK" "$1/plan/current/build-log.md" 2>&1); CODE=$?; }

echo "=== AC-1: a Start later than the first artifact commit fails ==="
world late 2026-11-10T12:20:00Z 10 yes
run_check "$TMP/late"
assert_contains "P1: Start" "$OUT" "AC-1: the finding names P1"
assert_contains "first artifact commit" "$OUT" "AC-1: the finding names the first artifact commit"

echo "=== AC-2: a Start at or before the first artifact commit passes ==="
world early 2026-11-10T12:01:00Z 29 yes
run_check "$TMP/early"
assert_not_contains "first artifact commit" "$OUT" "AC-2: no check 10 finding"

echo "=== AC-3: a phase with no committed artifact is skipped ==="
world none 2026-11-10T12:20:00Z 10 no
run_check "$TMP/none"
assert_not_contains "first artifact commit" "$OUT" "AC-3: no artifact, no finding"

echo "=== AC-3: a log outside git is skipped ==="
mkdir -p "$TMP/nogit"
log "$TMP/nogit/build-log.md" 2026-11-10T12:20:00Z 10
OUT=$(node "$CHECK" "$TMP/nogit/build-log.md" 2>&1)
assert_not_contains "first artifact commit" "$OUT" "AC-3: a log outside git gives no finding"

print_summary
