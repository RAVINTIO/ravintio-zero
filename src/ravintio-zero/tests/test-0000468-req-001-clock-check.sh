#!/usr/bin/env bash
# Tests for feature 0000468-reply-time-matches-the-clock, req-001: check-reply-prefix
# compares a leading hh:mm with the local clock and warns past the margin.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"

TMP=$(mktemp -d -t ravintio_0000468_req001_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

new_project() {
  local d
  d=$(mktemp -d "$TMP/proj_XXXXXX")
  mkdir -p "$d/plan/current"
  : > "$d/plan/.orchestrator-active"
  echo "$d"
}

write_transcript() {
  node -e '
    const [file, text] = process.argv.slice(1);
    const fs = require("node:fs");
    fs.writeFileSync(file, [
      JSON.stringify({ type: "user", message: { role: "user", content: "hi" } }),
      JSON.stringify({ type: "assistant", message: { role: "assistant", content: text } }),
    ].join("\n") + "\n");
  ' "$1" "$2"
}

# run_hook <project> <clock> <reply> [margin]
run_hook() {
  local payload
  write_transcript "$TMP/t.jsonl" "$3"
  payload=$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], transcript_path: process.argv[2] }))' "$1" "$TMP/t.jsonl")
  if [ -n "${4:-}" ]; then
    OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP RAVINTIO_REPLY_CLOCK="$2" RAVINTIO_REPLY_MARGIN_MIN="$4" node "$HOOK" 2>/dev/null)
  else
    OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP -u RAVINTIO_REPLY_MARGIN_MIN RAVINTIO_REPLY_CLOCK="$2" node "$HOOK" 2>/dev/null)
  fi
  CODE=$?
}

LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

echo ""
echo "=== req-001 AC-1: a time inside the margin passes ==="
P=$(new_project)
for T in 14:32 14:30 14:28 14:29 14:31; do
  run_hook "$P" 14:30 "$T P2 Implement: Starting: x"
  assert_equals "0" "$CODE" "req-001 AC-1: $T against 14:30 exits 0"
  assert_equals "" "$OUT" "req-001 AC-1: $T against 14:30 prints nothing"
done
assert_equals "0" "$(log_lines "$P")" "req-001 AC-1: no miss is logged"

echo ""
echo "=== req-001 AC-2: a time outside the margin warns ==="
P=$(new_project)
run_hook "$P" 14:30 "13:30 P2 Implement: Starting: x"
assert_equals "0" "$CODE" "req-001 AC-2: an hour off exits 0"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-2: an hour off warns"
assert_contains "13:30" "$OUT" "req-001 AC-2: the warning names the reply time"
assert_contains "14:30" "$OUT" "req-001 AC-2: the warning names the clock"
assert_equals "1" "$(log_lines "$P")" "req-001 AC-2: one log line"
run_hook "$P" 14:30 "14:36 P2 Implement: Starting: x"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-2: 6 minutes off warns"
assert_equals "2" "$(log_lines "$P")" "req-001 AC-2: a second log line"
run_hook "$P" 14:30 "14:36 P2 Implement: Starting: x" 10
assert_equals "" "$OUT" "req-001 AC-2: a margin of 10 lets 6 minutes pass"
run_hook "$P" 14:30 "14:36 P2 Implement: Starting: x" nonsense
assert_contains '"systemMessage"' "$OUT" "req-001 AC-2: an unparsable margin keeps the default"
run_hook "$P" nonsense "14:36 P2 Implement: Starting: x"
assert_equals "0" "$CODE" "req-001 AC-2: an unparsable clock exits 0"

echo ""
echo "=== req-001 AC-3: the check wraps at midnight ==="
P=$(new_project)
run_hook "$P" 00:01 "23:59 P2 Implement: Starting: x"
assert_equals "" "$OUT" "req-001 AC-3: 23:59 against 00:01 passes"
run_hook "$P" 23:59 "00:01 P2 Implement: Starting: x"
assert_equals "" "$OUT" "req-001 AC-3: 00:01 against 23:59 passes"
run_hook "$P" 00:01 "23:50 P2 Implement: Starting: x"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-3: 23:50 against 00:01 warns"
assert_equals "0" "$CODE" "req-001 AC-3: the hook exits 0"

echo ""
echo "=== req-001 AC-4: no time passes, a bad prefix still warns ==="
P=$(new_project)
run_hook "$P" 14:30 "P2 Implement: Starting: x"
assert_equals "" "$OUT" "req-001 AC-4: a reply with no time passes"
run_hook "$P" 14:30 "14:30 Plain reply"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-4: a time with no prefix warns"

print_summary
