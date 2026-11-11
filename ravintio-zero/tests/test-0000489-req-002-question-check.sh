#!/usr/bin/env bash
# Tests for feature 0000489-question-only-for-questions, req-002: check-reply-prefix warns on a
# Question: status line that holds no question mark.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"

TMP=$(mktemp -d -t ravintio_0000489_req002_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

new_project() {
  local d
  d=$(mktemp -d "$TMP/proj_XXXXXX")
  mkdir -p "$d/plan/current"
  : > "$d/plan/.orchestrator-active"
  echo "$d"
}

# run_hook <project> <reply>
run_hook() {
  local payload
  payload=$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], last_assistant_message: process.argv[2] }))' "$1" "$2")
  OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP RAVINTIO_REPLY_CLOCK=14:30 node "$HOOK" 2>/dev/null)
  CODE=$?
}

LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

echo ""
echo "=== req-002 AC-1: a false question warns ==="
P=$(new_project)
run_hook "$P" "14:30 I-C Run: Question: step 31 is partway through"
assert_equals "0" "$CODE" "req-002 AC-1: the hook exits 0"
assert_contains '"systemMessage"' "$OUT" "req-002 AC-1: the hook warns"
assert_contains "Question check" "$OUT" "req-002 AC-1: the warning names the Question check"
assert_contains "does not mean a run stopped" "$OUT" "req-002 AC-1: the warning says the run did not stop"
assert_equals "1" "$(log_lines "$P")" "req-002 AC-1: one log line"
assert_contains "question: " "$(cat "$P/$LOG_REL")" "req-002 AC-1: the log line is tagged"
run_hook "$P" "I-C Run: Question: waiting on the suites"
assert_contains "Question check" "$OUT" "req-002 AC-1: a reply with no time warns"

echo ""
echo "=== req-002 AC-2: a real question passes ==="
P=$(new_project)
run_hook "$P" "14:30 I-C Run: Question: Which branch should the step use?"
assert_equals "" "$OUT" "req-002 AC-2: a question with a mark prints nothing"
assert_equals "0" "$(log_lines "$P")" "req-002 AC-2: nothing is logged"

echo ""
echo "=== req-002 AC-3: other statuses pass and the hook exits 0 ==="
P=$(new_project)
run_hook "$P" "14:30 I-D Advance: Blocked: CI failed on PR 12"
assert_equals "" "$OUT" "req-002 AC-3: Blocked with no mark prints nothing"
assert_equals "0" "$CODE" "req-002 AC-3: Blocked exits 0"
run_hook "$P" "14:30 P2 Implement: Complete: two units"
assert_equals "" "$OUT" "req-002 AC-3: Complete with no mark prints nothing"
run_hook "$P" "14:30 Plain reply: Question: x"
assert_contains "Reply prefix check" "$OUT" "req-002 AC-3: a missing prefix keeps the prefix warning"
assert_not_contains "Question check" "$OUT" "req-002 AC-3: a missing prefix draws no Question warning"
assert_equals "1" "$(log_lines "$P")" "req-002 AC-3: the prefix miss logs once"

print_summary
