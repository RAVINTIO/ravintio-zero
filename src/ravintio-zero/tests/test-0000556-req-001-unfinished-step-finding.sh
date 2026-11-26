#!/usr/bin/env bash
# Tests for feature 0000556-step-session-finds-unfinished-step, req-001:
# resume detection finds a step session with no build log and no archive.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SCRIPT="$ZERO_DIR/scripts/resume-detect.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

ID="0000556-sample-step"
FINDING="unfinished step: no build log and no archive, start P0"

# make_ws <name>: a repo on feat/$ID, two commits past initiative/sample
make_ws() {
  local ws="$WORK/$1"
  mkdir -p "$ws/plan/current-initiative"
  printf '**Status:** active\n**Branch:** initiative/sample\n**Position:** 1\n' > "$ws/plan/current-initiative/initiative.md"
  (
    cd "$ws" || exit 1
    git init -q -b initiative/sample .
    git config user.email t@example.com
    git config user.name t
    git add -A && git commit -qm base
    git checkout -q -b "feat/$ID"
    echo a > a.txt && git add a.txt && git commit -qm one
    echo b > b.txt && git add b.txt && git commit -qm two
  )
  echo "$ws"
}

# detect <ws> [step=1]
detect() {
  if [ "${2:-1}" = 1 ]; then
    RAVINTIO_INITIATIVE_STEP=1 node "$SCRIPT" "$1" 2>/dev/null
  else
    env -u RAVINTIO_INITIATIVE_STEP node "$SCRIPT" "$1" 2>/dev/null
  fi
}

echo ""
echo "=== req-001 AC-1: the finding prints ==="
ws="$(make_ws one)"
OUT="$(detect "$ws")"
assert_contains "$FINDING" "$OUT" "AC-1: the unfinished-step line prints"
assert_contains "step branch commits: 2" "$OUT" "AC-1: the commit count prints"

echo ""
echo "=== req-001 AC-2: the finding stays silent ==="
ws="$(make_ws two)"
mkdir -p "$ws/plan/current" && touch "$ws/plan/current/build-log.md"
assert_not_contains "unfinished step" "$(detect "$ws")" "AC-2: a build log silences it"
ws="$(make_ws three)"
mkdir -p "$ws/plan/_archive/$ID-2026-11-15"
assert_not_contains "unfinished step" "$(detect "$ws")" "AC-2: an archive folder silences it"
ws="$(make_ws four)"
assert_not_contains "unfinished step" "$(detect "$ws" 0)" "AC-2: no step session, no finding"
mkdir -p "$WORK/plain/plan/current-initiative"
cp "$WORK/four/plan/current-initiative/initiative.md" "$WORK/plain/plan/current-initiative/"
OUT="$(detect "$WORK/plain")"
assert_not_contains "unfinished step" "$OUT" "AC-2: a folder with no git repo prints nothing"
assert_not_contains "step branch commits" "$OUT" "AC-2: a folder with no git repo prints no count"

echo ""
echo "=== req-001 AC-3: the reference maps the lines ==="
assert_rule resume-initiative "$FINDING" "step branch commits" "start P0"

print_summary
