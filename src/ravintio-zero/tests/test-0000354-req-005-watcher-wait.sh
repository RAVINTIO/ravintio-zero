#!/usr/bin/env bash
# Tests for feature 0000354-steps-run-to-the-end, req-005: the watcher waits for the build log
# and names the running step.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WATCH="$SCRIPT_DIR/../scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com

# make_repo <name>: a repo at position 6 with an archived build log dated 00:00 and a held lock.
make_repo() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/_archive/0000999-old-2026-01-01" "$d/plan/.initiative-logs"
  printf 'status: active\nposition: 6\n' > "$d/plan/current-initiative/initiative.md"
  printf '### P4: Ship\nI-D Advance: Complete: step 5 done\n' > "$d/plan/_archive/0000999-old-2026-01-01/build-log.md"
  : > "$d/plan/.initiative-runner.lock"
  git -C "$d" init -q
  git -C "$d" add -A
  GIT_COMMITTER_DATE="2026-01-01T00:00:00Z" git -C "$d" commit -q -m "first commit" --date "2026-01-01T00:00:00Z"
  node -e "const t=new Date('2026-01-01T00:00:00Z');require('fs').utimesSync(process.argv[1],t,t)" "$d/plan/_archive/0000999-old-2026-01-01/build-log.md"
  echo "$d"
}

watch() {
  local root="$1"; shift
  OUT="$(node "$WATCH" --root "$root" --once "$@" 2>&1)"
  CODE=$?
}

count() { printf '%s\n' "$OUT" | grep -c "$1"; }

echo ""
echo "=== req-005 AC-1: no build log means a waiting line and no stale line ==="
R="$(make_repo a)"
FIRST="$(git -C "$R" rev-parse HEAD)"
echo x > "$R/f.txt"; git -C "$R" add f.txt
GIT_COMMITTER_DATE="2026-01-01T01:00:00Z" git -C "$R" commit -q -m "later commit" --date "2026-01-01T01:00:00Z"
watch "$R" --since-commit "$FIRST" --now "2026-01-01T02:00:00Z"
assert_exit_zero "$CODE" "AC-1: exits 0"
assert_equals "1" "$(count 'I-C Run: waiting for the build log')" "AC-1: prints the waiting line once"
assert_equals "0" "$(count 'I-C Run: stale:')" "AC-1: prints no stale line"

echo ""
echo "=== req-005 AC-1b: the waiting line prints once per absence ==="
watch "$R" --since-commit "$FIRST" --passes 3 --now "2026-01-01T02:00:00Z"
assert_equals "1" "$(count 'I-C Run: waiting for the build log')" "AC-1b: three passes give one waiting line"

echo ""
echo "=== req-005 AC-1c: a present build log keeps the stale check ==="
R="$(make_repo c)"
FIRST="$(git -C "$R" rev-parse HEAD)"
mkdir -p "$R/plan/current"
printf '### P0: Discover\n' > "$R/plan/current/build-log.md"
node -e "const t=new Date('2026-01-01T00:00:00Z');require('fs').utimesSync(process.argv[1],t,t)" "$R/plan/current/build-log.md"
echo x > "$R/f.txt"; git -C "$R" add f.txt
GIT_COMMITTER_DATE="2026-01-01T00:30:00Z" git -C "$R" commit -q -m "later commit" --date "2026-01-01T00:30:00Z"
watch "$R" --since-commit "$FIRST" --now "2026-01-01T01:00:00Z"
assert_equals "1" "$(count 'I-C Run: stale:')" "AC-1c: stale still prints with a build log"
assert_equals "0" "$(count 'waiting for the build log')" "AC-1c: no waiting line with a build log"

echo ""
echo "=== req-005 AC-2: the heartbeat names the running step ==="
R="$(make_repo b)"
printf '{"type":"system"}\n' > "$R/plan/.initiative-logs/step-5.log"
printf '{"type":"system"}\n' > "$R/plan/.initiative-logs/step-5.attempt-1.log"
printf '{"type":"system"}\n' > "$R/plan/.initiative-logs/step-3.log"
node -e "const f=require('fs');f.utimesSync(process.argv[1],new Date('2026-01-01T00:00:00Z'),new Date('2026-01-01T00:00:00Z'));f.utimesSync(process.argv[2],new Date('2026-01-01T00:10:00Z'),new Date('2026-01-01T00:10:00Z'));f.utimesSync(process.argv[3],new Date('2026-01-01T00:20:00Z'),new Date('2026-01-01T00:20:00Z'))" "$R/plan/.initiative-logs/step-3.log" "$R/plan/.initiative-logs/step-5.attempt-1.log" "$R/plan/.initiative-logs/step-5.log"
watch "$R" --now "2026-01-01T00:30:00Z"
assert_contains "heartbeat: step 5," "$OUT" "AC-2: the heartbeat names step 5, not the chart position 6"

R="$(make_repo d)"
watch "$R" --now "2026-01-01T00:30:00Z"
assert_contains "heartbeat: step 6," "$OUT" "AC-2: with no step log the heartbeat falls back to the chart position"

print_summary
