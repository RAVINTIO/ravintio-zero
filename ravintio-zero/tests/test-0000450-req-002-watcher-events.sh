#!/usr/bin/env bash
# Tests for feature 0000450-coordinator-status-view, req-002: watcher events and chart state.
#
# The watcher prints an event for a new ready file, a queue stop line, and a driver exit.
# It reads the chart so a merged step is never ready or running. Each heartbeat ends with
# the merged count. Event tests run the watcher without --once, because a new file must
# appear after the first pass. The poll interval is 10 seconds.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WATCH="$SCRIPT_DIR/../scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
PIDS=""
trap 'for p in $PIDS; do kill "$p" 2>/dev/null; done; rm -rf "$WORK"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com

CHART='status: active
position: 3

## Steps

| Step | Feature id | Title | Bump | Version | Status | After |
|------|------------|-------|------|---------|--------|-------|
| 1 | 0000001-one | One | minor | 0.1.0 | merged | none |
| 2 | 0000002-two | Two | minor | 0.2.0 | pending | none |
| 3 | 0000003-three | Three | minor | 0.3.0 | pending | none |
'

# make_repo <name> [chart text]
make_repo() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current" "$d/plan/.initiative-logs"
  printf '%s\n' "${2-$CHART}" > "$d/plan/current-initiative/initiative.md"
  printf '### P0: Discover\n' > "$d/plan/current/build-log.md"
  : > "$d/plan/.initiative-runner.lock"
  git -C "$d" init -q
  git -C "$d" add -A
  GIT_COMMITTER_DATE="2026-01-01T00:00:00Z" git -C "$d" commit -q -m "first commit" --date "2026-01-01T00:00:00Z"
  echo "$d"
}

watch() {
  local root="$1"; shift
  OUT="$(node "$WATCH" --root "$root" --once "$@" 2>&1)"
  CODE=$?
}

count() { printf '%s\n' "$OUT" | grep -c -F -- "$1"; }

echo ""
echo "=== AC-1, AC-2, AC-3: live events across two passes ==="
A="$(make_repo live)"
B="$(make_repo mergedready)"
mkdir -p "$A/plan/.initiative-control/step-2" "$B/plan/.initiative-control/step-1"
echo 41 > "$A/plan/.initiative-control/step-2/ready"
printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"hi"}]}}' > "$A/plan/.initiative-logs/step-3.log"
node "$WATCH" --root "$A" > "$WORK/a.out" 2>&1 &
PIDS="$PIDS $!"
node "$WATCH" --root "$B" > "$WORK/b.out" 2>&1 &
PIDS="$PIDS $!"
sleep 2
# Between passes: a new ready file, a stop line, and a lock removal.
mkdir -p "$A/plan/.initiative-control/step-3"
echo 57 > "$A/plan/.initiative-control/step-3/ready"
printf '09:15 I-D Advance: Blocked: queue stopped on step 3: CI red\nI-D Advance: Blocked: queue stopped on step 1: old\nnoise\n' >> "$A/plan/.initiative-logs/step-3.log"
echo 99 > "$B/plan/.initiative-control/step-1/ready"
printf 'I-D Advance: Blocked: queue stopped on step 1: old\n' >> "$B/plan/.initiative-logs/step-1.log"
rm "$A/plan/.initiative-runner.lock"
sleep 11
OUT="$(cat "$WORK/a.out")"
assert_equals "1" "$(count 'I-C Run: event: step 3 ready PR #57')" "AC-1: a new ready file prints one event"
assert_equals "0" "$(count 'event: step 2 ready')" "AC-1: a ready file present on the first pass is not new"
assert_equals "1" "$(count 'I-C Run: event: 09:15 I-D Advance: Blocked: queue stopped on step 3')" "a stop line prints once with its prefix"
assert_equals "0" "$(count 'queue stopped on step 1')" "a stop line for a merged step prints nothing"
assert_equals "1" "$(count 'I-C Run: event: driver exited')" "AC-3: a lock that disappears prints one exit event"
OUT="$(cat "$WORK/b.out")"
assert_equals "0" "$(count 'ready PR')" "AC-2: a merged step prints no ready event or heartbeat"
assert_equals "0" "$(count 'queue stopped')" "AC-2: a merged step prints no stop event"
assert_equals "0" "$(count 'driver exited')" "AC-3: a held lock prints no exit event"
for p in $PIDS; do kill "$p" 2>/dev/null; done
wait 2>/dev/null
PIDS=""

echo ""
echo "=== A ready file with no running file prints no heartbeat line ==="
R="$(make_repo noready)"
mkdir -p "$R/plan/.initiative-control/step-2"
echo abc > "$R/plan/.initiative-control/step-2/ready"
watch "$R"
assert_exit_zero "$CODE" "exits 0"
assert_not_contains "ready PR" "$OUT" "the single-step heartbeat form stays unchanged"

echo ""
echo "=== A merged step is not listed as running or ready ==="
R="$(make_repo mergedrun)"
mkdir -p "$R/plan/.initiative-control/step-1" "$R/plan/.initiative-control/step-2"
echo 1 > "$R/plan/.initiative-control/step-1/running"
echo 5 > "$R/plan/.initiative-control/step-1/ready"
echo 1 > "$R/plan/.initiative-control/step-2/running"
mkdir -p "$R/plan/.initiative-worktrees/step-2/plan/current"
watch "$R"
assert_not_contains "step 1," "$OUT" "no concurrent heartbeat for a merged step"
assert_contains "heartbeat: step 2," "$OUT" "an unmerged running step still prints"

echo ""
echo "=== The heartbeat carries the merged count ==="
R="$(make_repo beat)"
watch "$R"
assert_contains "lock held, merged 1 of 3" "$OUT" "heartbeat ends with the merged count"
R="$(make_repo nosteps 'status: active
position: 3')"
watch "$R"
assert_exit_zero "$CODE" "a chart with no steps table does not stop the watcher"
assert_contains "heartbeat:" "$OUT" "a chart with no steps table still prints a heartbeat"
assert_not_contains "merged " "$OUT" "no merged count without steps"
R="$(make_repo badchart '## Steps

| Step | Status |
|------|--------|
| 1 | bogus |')"
watch "$R"
assert_exit_zero "$CODE" "a malformed chart does not stop the watcher"
assert_contains "heartbeat:" "$OUT" "a malformed chart still prints a heartbeat"
R="$(make_repo nochart)"
rm "$R/plan/current-initiative/initiative.md"
watch "$R"
assert_exit_zero "$CODE" "a missing chart does not stop the watcher"

print_summary
