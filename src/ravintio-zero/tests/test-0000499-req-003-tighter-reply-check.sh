#!/usr/bin/env bash
# Tests for feature 0000499-reply-times-match-clock, req-003: a 2 minute margin and a status check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"
TMP=$(mktemp -d -t ravintio_0000499_req003_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

new_project() {
  local d
  d=$(mktemp -d "$TMP/proj_XXXXXX")
  mkdir -p "$d/plan/current"
  : > "$d/plan/.orchestrator-active"
  echo "$d"
}

# run_hook <project> <clock> <reply>
run_hook() {
  node -e '
    const fs = require("node:fs");
    fs.writeFileSync(process.argv[1], [
      JSON.stringify({ type: "user", message: { role: "user", content: "hi" } }),
      JSON.stringify({ type: "assistant", message: { role: "assistant", content: process.argv[2] } }),
    ].join("\n") + "\n");
  ' "$TMP/t.jsonl" "$3"
  local payload
  payload=$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], transcript_path: process.argv[2] }))' "$1" "$TMP/t.jsonl")
  OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP -u RAVINTIO_REPLY_MARGIN_MIN RAVINTIO_REPLY_CLOCK="$2" node "$HOOK" 2>/dev/null)
  CODE=$?
}
LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

echo ""
echo "=== AC-1: a 3 minute gap warns, 2 minutes pass ==="
P=$(new_project)
run_hook "$P" 10:00 "10:02 P2 Implement: Starting: x"
assert_equals "" "$OUT" "AC-1: 2 minutes pass"
run_hook "$P" 10:00 "10:03 P2 Implement: Starting: x"
assert_contains '"systemMessage"' "$OUT" "AC-1: 3 minutes warn"
assert_equals "1" "$(log_lines "$P")" "AC-1: one log line"

echo ""
echo "=== AC-2: an unknown status warns ==="
P=$(new_project)
run_hook "$P" 10:00 "10:00 P4 Ship: Running: x"
assert_equals "0" "$CODE" "AC-2: exits 0"
assert_contains "Status check" "$OUT" "AC-2: the warning names the Status check"
assert_contains "status:" "$(cat "$P/$LOG_REL")" "AC-2: the log line starts with status:"

echo ""
echo "=== AC-3: valid replies pass ==="
P=$(new_project)
for S in Starting Resuming Complete Blocked Skipped Ready Restart; do
  run_hook "$P" 10:00 "10:01 P4 Ship: $S: x"
  assert_equals "" "$OUT" "AC-3: $S passes"
  assert_equals "0" "$CODE" "AC-3: $S exits 0"
done
run_hook "$P" 10:00 "10:01 P4 Ship: Question: which one?"
assert_equals "" "$OUT" "AC-3: a real question passes"
run_hook "$P" 10:00 "10:01 Supervise:"
assert_equals "" "$OUT" "AC-3: a prefix with no status is not checked"
assert_equals "0" "$(log_lines "$P")" "AC-3: no log line"

print_summary
