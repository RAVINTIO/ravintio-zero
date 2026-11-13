#!/usr/bin/env bash
# Tests for feature 0000388-replies-and-questions, req-002: the prefix warning
# names the check, quotes the reply, names the session, and skips the
# coordinator while the driver lock exists (ADR-001).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"

TMP=$(mktemp -d -t ravintio_0000388_req002_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

new_project() {
  local d
  d=$(mktemp -d "$TMP/proj_XXXXXX")
  mkdir -p "$d/plan"
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

# run_hook CWD TRANSCRIPT [STEP]: STEP "1" sets RAVINTIO_INITIATIVE_STEP=1.
run_hook() {
  local payload
  payload=$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], transcript_path: process.argv[2] }))' "$1" "$2")
  if [ "${3:-}" = "1" ]; then
    OUT=$(printf '%s' "$payload" | RAVINTIO_INITIATIVE_STEP=1 node "$HOOK" 2>/dev/null)
  else
    OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP node "$HOOK" 2>/dev/null)
  fi
  CODE=$?
}

LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

REPLY="Here is the result of the check you asked for, with a long tail of words that runs past the quote limit"

echo ""
echo "=== req-002 AC-1: the warning names check, reply, and session ==="
P=$(new_project)
write_transcript "$TMP/t.jsonl" "$REPLY"
run_hook "$P" "$TMP/t.jsonl"
assert_equals "0" "$CODE" "req-002 AC-1: the hook exits 0"
assert_contains "Reply prefix check" "$OUT" "req-002 AC-1: the warning names the check"
assert_contains "Here is the result of the check" "$OUT" "req-002 AC-1: the warning quotes the reply"
assert_not_contains "runs past the quote limit" "$OUT" "req-002 AC-1: the quote is cut short"
assert_contains "this session" "$OUT" "req-002 AC-1: the warning names the coordinator session"
assert_contains "does not mean" "$OUT" "req-002 AC-1: the warning says it is not a stopped run"
assert_contains "plan/.prefix-misses.log" "$OUT" "req-002 AC-1: the warning names the miss log"
assert_not_contains "Reply is missing" "$OUT" "req-002 AC-1: the old wording is gone"
assert_equals "1" "$(log_lines "$P")" "req-002 AC-1: one miss is logged"

run_hook "$P" "$TMP/t.jsonl" 1
assert_contains "step session" "$OUT" "req-002 AC-1: a step session is named"

write_transcript "$TMP/tc.jsonl" $'Line one\twith\x01control chars'
run_hook "$P" "$TMP/tc.jsonl"
validate_json "$OUT" >/dev/null 2>&1
assert_contains "Line one" "$OUT" "req-002 AC-1: a reply with control characters still quotes"

echo ""
echo "=== req-002 AC-2: the coordinator skip while the driver lock exists ==="
P=$(new_project)
: > "$P/plan/.initiative-runner.lock"
write_transcript "$TMP/t.jsonl" "$REPLY"
run_hook "$P" "$TMP/t.jsonl"
assert_equals "0" "$CODE" "req-002 AC-2: the hook exits 0"
assert_equals "" "$OUT" "req-002 AC-2: the coordinator gets no warning"
assert_equals "0" "$(log_lines "$P")" "req-002 AC-2: the coordinator logs no miss"

run_hook "$P" "$TMP/t.jsonl" 1
assert_contains "Reply prefix check" "$OUT" "req-002 AC-2: a step session with the lock still warns"
assert_equals "1" "$(log_lines "$P")" "req-002 AC-2: a step session logs the miss"

P=$(new_project)
run_hook "$P" "$TMP/t.jsonl"
assert_contains "Reply prefix check" "$OUT" "req-002 AC-2: with no lock the check runs"

print_summary
