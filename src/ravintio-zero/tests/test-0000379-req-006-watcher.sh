#!/usr/bin/env bash
# Tests for feature 0000379-parallel-steps-on-worktrees, req-006 AC-1: concurrent watcher.
#
# With plan/.initiative-control/step-{n}/running files, initiative-watch.mjs reports every
# running step with its number. It reads each worktree build log and stream log.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WATCH="$SCRIPT_DIR/../scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com

make_repo() {
  local d="$WORK/$1"
  mkdir -p "$d/plan/current-initiative" "$d/plan/current" "$d/plan/.initiative-logs"
  printf 'status: active\nposition: 3\n' > "$d/plan/current-initiative/initiative.md"
  printf '### P0: Discover\nP0 Discover: Complete: brief written\n' > "$d/plan/current/build-log.md"
  : > "$d/plan/.initiative-runner.lock"
  git -C "$d" init -q
  git -C "$d" add -A
  GIT_COMMITTER_DATE="2026-01-01T00:00:00Z" git -C "$d" commit -q -m "first commit" --date "2026-01-01T00:00:00Z"
  echo "$d"
}

# add_step <root> <n> <running|PR number> <build log text>
add_step() {
  local d="$1/plan/.initiative-control/step-$2"
  mkdir -p "$d" "$1/plan/.initiative-worktrees/step-$2/plan/current"
  echo 1234 > "$d/running"
  if [ "$3" != running ]; then echo "$3" > "$d/ready"; fi
  printf '%b' "$4" > "$1/plan/.initiative-worktrees/step-$2/plan/current/build-log.md"
}

watch() {
  local root="$1"; shift
  OUT="$(node "$WATCH" --root "$root" --once "$@" 2>&1)"
  CODE=$?
}

# --- AC-1: two running steps -------------------------------------------
R="$(make_repo two)"
add_step "$R" 2 running '### P1: Plan\nP1 Plan: Complete: plan done\n'
add_step "$R" 5 running '### P2: Implement\nP2 Implement: Complete: code done\n'
printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"a.txt"}}]}}' > "$R/plan/.initiative-logs/step-2.log"
printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"working on five"}]}}' > "$R/plan/.initiative-logs/step-5.log"
watch "$R" --since-lines 1 --since-bytes 0 --now "2026-01-01T00:02:00Z"
assert_exit_zero "$CODE" "REQ-006 AC-1: concurrent run exits 0"
assert_contains "I-C Run: heartbeat: step 2, phase P1" "$OUT" "REQ-006 AC-1: heartbeat for step 2"
assert_contains "I-C Run: heartbeat: step 5, phase P2" "$OUT" "REQ-006 AC-1: heartbeat for step 5"
assert_contains "I-C Run: event: step 2: P1 Plan: Complete: plan done" "$OUT" "REQ-006 AC-1: event tagged step 2"
assert_contains "I-C Run: event: step 5: P2 Implement: Complete: code done" "$OUT" "REQ-006 AC-1: event tagged step 5"
assert_contains "I-C Run: activity: step 2: tool: Read a.txt" "$OUT" "REQ-006 AC-1: activity tagged step 2"
assert_contains "I-C Run: activity: step 5: text: working on five" "$OUT" "REQ-006 AC-1: activity tagged step 5"

# --- AC-1: ready step shows its PR -------------------------------------
R="$(make_repo ready)"
add_step "$R" 2 running '### P2: Implement\n'
add_step "$R" 7 42 '### P3: Validate\n'
watch "$R" --now "2026-01-01T00:02:00Z"
assert_contains "I-C Run: heartbeat: step 7, ready PR #42" "$OUT" "REQ-006 AC-1: ready step shows its PR"
assert_contains "I-C Run: heartbeat: step 2, phase P2" "$OUT" "REQ-006 AC-1: running step still shown"

# --- AC-1: invalid step number is ignored ------------------------------
R="$(make_repo bad)"
add_step "$R" 2 running '### P1: Plan\n'
mkdir -p "$R/plan/.initiative-control/step-0" "$R/plan/.initiative-control/step-1234"
echo 1 > "$R/plan/.initiative-control/step-0/running"
echo 1 > "$R/plan/.initiative-control/step-1234/running"
watch "$R" --now "2026-01-01T00:02:00Z"
assert_equals "1" "$(printf '%s\n' "$OUT" | grep -c 'I-C Run: heartbeat:')" "REQ-006 AC-1: invalid step numbers are ignored"

# --- AC-1: symlinked running file is refused ---------------------------
R="$(make_repo link)"
add_step "$R" 2 running '### P1: Plan\n'
rm "$R/plan/.initiative-control/step-2/running"
ln -s /etc/hosts "$R/plan/.initiative-control/step-2/running"
watch "$R" --now "2026-01-01T00:02:00Z"
assert_equals "1" "$CODE" "REQ-006 AC-1: symlink refused with exit 1"
assert_contains "refused a symlinked plan path" "$OUT" "REQ-006 AC-1: symlink refusal message"

# --- AC-1: old-style fixture is unchanged ------------------------------
R="$(make_repo old)"
watch "$R" --now "2026-01-01T00:02:00Z"
assert_contains "I-C Run: heartbeat: step 3, phase P0" "$OUT" "REQ-006 AC-1: old-style heartbeat unchanged"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c 'step [0-9]*:')" "REQ-006 AC-1: old-style prints no tagged lines"

print_summary
