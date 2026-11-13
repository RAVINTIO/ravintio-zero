#!/usr/bin/env bash
# Tests for feature 0000499-reply-times-match-clock, req-004: the watcher stamps activity lines.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WATCH="$SCRIPT_DIR/../scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com

R="$WORK/repo"
mkdir -p "$R/plan/current-initiative" "$R/plan/current" "$R/plan/.initiative-logs"
printf 'status: active\nposition: 3\n' > "$R/plan/current-initiative/initiative.md"
printf '### P0: Discover\n' > "$R/plan/current/build-log.md"
: > "$R/plan/.initiative-runner.lock"
git -C "$R" init -q
git -C "$R" add -A
git -C "$R" commit -q -m "first commit"

echo ""
echo "=== AC-1: an activity line carries the time ==="
printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"a.txt"}}]}}' > "$R/plan/.initiative-logs/step-3.log"
OUT="$(RAVINTIO_REPLY_CLOCK=09:15 node "$WATCH" --root "$R" --once --since-lines 1 --since-bytes 0 2>&1)"
ACT="$(printf '%s\n' "$OUT" | grep 'I-C Run: activity:')"
assert_contains "09:15 I-C Run: activity: tool: Read a.txt" "$ACT" "AC-1: the line starts with the time"

echo ""
echo "=== AC-2: the cut stays at 200 characters before the stamp ==="
LONG=$(printf 'a%.0s' $(seq 1 400))
printf '%s\n' "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Bash\",\"input\":{\"command\":\"$LONG\"}}]}}" > "$R/plan/.initiative-logs/step-3.log"
OUT="$(RAVINTIO_REPLY_CLOCK=09:15 node "$WATCH" --root "$R" --once --since-lines 1 --since-bytes 0 2>&1)"
ACT="$(printf '%s\n' "$OUT" | grep 'I-C Run: activity:' | head -1)"
assert_contains "09:15 I-C Run: activity:" "$ACT" "AC-2: the long line is stamped"
assert_equals "206" "${#ACT}" "AC-2: the line is the 200 character cut plus the 6 character time"

print_summary
