#!/usr/bin/env bash
# Tests for feature 0000388-replies-and-questions, req-005: driver and watcher time.
#
# AC-1: every line that initiative-run.mjs and initiative-watch.mjs print starts with
# the local hh:mm and a space, then a known prefix.
# AC-2: the Reply Conventions text names the hh:mm time before the prefix.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO="$SCRIPT_DIR/.."
RUN="$ZERO/scripts/initiative-run.mjs"
WATCH="$ZERO/scripts/initiative-watch.mjs"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com

# all_timed <output>: prints "yes" when every line is hh:mm, a space, and a known prefix.
all_timed() {
  local bad
  bad="$(printf '%s\n' "$1" | grep -vE '^[0-2][0-9]:[0-5][0-9] (P[0-4] |I-[A-E] )' | grep -c .)"
  [ -n "$1" ] && [ "$bad" = 0 ] && echo yes || echo no
}

echo ""
echo "=== AC-1: watcher lines ==="
R="$WORK/w"
mkdir -p "$R/plan/current-initiative" "$R/plan/current"
printf 'status: active\nposition: 3\n' > "$R/plan/current-initiative/initiative.md"
printf '### P0: Discover\nP0 Discover: Complete: brief written\n' > "$R/plan/current/build-log.md"
: > "$R/plan/.initiative-runner.lock"
git -C "$R" init -q
git -C "$R" commit -q --allow-empty -m "first commit"
OUT="$(node "$WATCH" --root "$R" --once --since-lines 0 --since-bytes 0 2>&1)"
assert_contains "I-C Run: " "$OUT" "watcher prints I-C Run lines"
assert_equals "yes" "$(all_timed "$OUT")" "every watcher line starts with hh:mm and a prefix"

echo ""
echo "=== AC-1: driver lines ==="
mkdir -p "$WORK/d"
git -C "$WORK/d" init -q
OUT="$(node "$RUN" --root "$WORK/d" 2>/dev/null)"
assert_contains "I-C Run: " "$OUT" "driver prints an I-C Run line"
assert_equals "yes" "$(all_timed "$OUT")" "every driver line starts with hh:mm and a prefix"

echo ""
echo "=== AC-2: docs name the time ==="
for f in templates/standard-boot.md templates/codex-boot.md skills/ravintio-orchestrator/SKILL.md skills/ravintio-initiative/SKILL.md; do
  assert_contains 'hh:mm {prefix} {Status}: {one-liner}' "$(cat "$ZERO/$f")" "$f names the time before the prefix"
done
assert_rule reply-time-form 'hh:mm {prefix} {Status}: {one-liner}' 'UserPromptSubmit' 'with or without the time'

print_summary
