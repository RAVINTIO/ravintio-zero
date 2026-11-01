#!/usr/bin/env bash
# Tests for feature 0000320-quiet-session-start, req-004: the check-reply-prefix
# Stop hook checks the final reply and stays silent when it finds none.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"

TMP=$(mktemp -d -t ravintio_0000320_req004_XXXXXX)
trap 'rm -rf "$TMP"' EXIT

export RAVINTIO_PREFIX_REREAD_MS=50

new_project() {
  local d
  d=$(mktemp -d "$TMP/proj_XXXXXX")
  mkdir -p "$d/plan"
  : > "$d/plan/.orchestrator-active"
  echo "$d"
}

# write_transcript FILE SPEC...: build a JSONL transcript from entries.
# Each SPEC is KIND:TEXT. KIND is user, text (assistant text), tool (assistant
# tool_use block only), or mixed (assistant text plus a tool_use block).
write_transcript() {
  local file="$1"
  shift
  node -e '
    const [file, ...specs] = process.argv.slice(1);
    const lines = specs.map((s) => {
      const i = s.indexOf(":");
      const kind = s.slice(0, i), text = s.slice(i + 1);
      if (kind === "user") return { type: "user", message: { role: "user", content: text } };
      const content = kind === "text" ? [{ type: "text", text }]
        : kind === "tool" ? [{ type: "tool_use", name: "x" }]
        : [{ type: "text", text }, { type: "tool_use", name: "x" }];
      return { type: "assistant", message: { role: "assistant", content } };
    }).map((o) => JSON.stringify(o));
    require("node:fs").writeFileSync(file, lines.join("\n") + "\n");
  ' "$file" "$@"
}

# run_hook CWD TRANSCRIPT [MESSAGE_JSON]: run the hook with a Stop payload.
run_hook() {
  local payload
  payload=$(node -e '
    const p = { hook_event_name: "Stop", cwd: process.argv[1], transcript_path: process.argv[2] };
    if (process.argv[3] !== undefined) p.last_assistant_message = JSON.parse(process.argv[3]);
    console.log(JSON.stringify(p));
  ' "$@")
  OUT=$(printf '%s' "$payload" | node "$HOOK" 2>/dev/null)
  CODE=$?
}

LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

echo ""
echo "=== req-004 AC-1: a prefixed final reply gives no warning ==="
P=$(new_project)
write_transcript "$TMP/a1.jsonl" "user:go" "text:Unprefixed earlier note"
run_hook "$P" "$TMP/a1.jsonl" '"P2 Implement: Complete: done"'
assert_equals "0" "$CODE" "req-004 AC-1: the hook exits 0"
assert_equals "" "$OUT" "req-004 AC-1: the hook prints nothing"
assert_equals "0" "$(log_lines "$P")" "req-004 AC-1: the hook logs nothing"

echo ""
echo "=== req-004 AC-2: an unprefixed final reply warns and is quoted ==="
P=$(new_project)
write_transcript "$TMP/a2.jsonl" "user:go" "text:P2 Implement: earlier note"
run_hook "$P" "$TMP/a2.jsonl" '"Final reply with no prefix"'
assert_equals "0" "$CODE" "req-004 AC-2: the hook exits 0"
assert_contains '"systemMessage"' "$OUT" "req-004 AC-2: the hook warns"
assert_equals "1" "$(log_lines "$P")" "req-004 AC-2: one log line is appended"
LINE=$(head -n 1 "$P/$LOG_REL" 2>/dev/null)
assert_contains "Final reply with no prefix" "$LINE" "req-004 AC-2: the log quotes the final reply"
if [[ "$LINE" == *"earlier note"* ]]; then
  assert_equals "absent" "present" "req-004 AC-2: the log does not quote the earlier note"
else
  assert_equals "absent" "absent" "req-004 AC-2: the log does not quote the earlier note"
fi

echo ""
echo "=== req-004 AC-3: no final reply gives no warning ==="
P=$(new_project)
write_transcript "$TMP/a3.jsonl" "user:go" "text:Unprefixed earlier note" "tool:"
run_hook "$P" "$TMP/a3.jsonl"
assert_equals "0" "$CODE" "req-004 AC-3: the hook exits 0"
assert_equals "" "$OUT" "req-004 AC-3: the hook prints nothing"
assert_equals "0" "$(log_lines "$P")" "req-004 AC-3: the hook logs nothing"

echo ""
echo "=== req-004: transcript fallback ==="
P=$(new_project)
write_transcript "$TMP/f1.jsonl" "user:go" "mixed:Unprefixed note" "text:Plain final reply"
run_hook "$P" "$TMP/f1.jsonl"
assert_contains '"systemMessage"' "$OUT" "req-004: an unprefixed final reply in the transcript warns"
assert_contains "Plain final reply" "$(cat "$P/$LOG_REL" 2>/dev/null)" "req-004: the log quotes the transcript final reply"

P=$(new_project)
write_transcript "$TMP/f2.jsonl" "user:go" "text:Plain note" "tool:" "user:next" "text:P1 Plan: final"
run_hook "$P" "$TMP/f2.jsonl"
assert_equals "" "$OUT" "req-004: a prefixed final reply after the last prompt passes"
assert_equals "0" "$(log_lines "$P")" "req-004: a prefixed final reply logs nothing"

P=$(new_project)
write_transcript "$TMP/f3.jsonl" "user:go" "text:Plain reply to an older prompt" "user:next"
run_hook "$P" "$TMP/f3.jsonl"
assert_equals "" "$OUT" "req-004: a reply before the last prompt is not checked"
assert_equals "0" "$(log_lines "$P")" "req-004: a reply before the last prompt logs nothing"

P=$(new_project)
write_transcript "$TMP/f4.jsonl" "user:go" "mixed:Plain note with a tool call"
run_hook "$P" "$TMP/f4.jsonl"
assert_equals "" "$OUT" "req-004: a message with a tool_use block is not a final reply"
assert_equals "0" "$(log_lines "$P")" "req-004: a message with a tool_use block logs nothing"

echo ""
echo "=== req-004: rereading finds a late final reply ==="
P=$(new_project)
write_transcript "$TMP/late.jsonl" "user:go" "tool:"
(
  sleep 0.12
  write_transcript "$TMP/late.jsonl" "user:go" "tool:" "text:Late plain reply"
) &
run_hook "$P" "$TMP/late.jsonl"
wait
assert_contains '"systemMessage"' "$OUT" "req-004: a reply written after a delay is found"
assert_contains "Late plain reply" "$(cat "$P/$LOG_REL" 2>/dev/null)" "req-004: the log quotes the late reply"

echo ""
echo "=== req-004: unusable last_assistant_message falls back ==="
for BAD in '""' '"   "' '42' 'null' '{"a":1}'; do
  P=$(new_project)
  write_transcript "$TMP/b.jsonl" "user:go" "text:Plain fallback reply"
  run_hook "$P" "$TMP/b.jsonl" "$BAD"
  assert_contains '"systemMessage"' "$OUT" "req-004: last_assistant_message $BAD falls back to the transcript"
  assert_contains "Plain fallback reply" "$(cat "$P/$LOG_REL" 2>/dev/null)" "req-004: $BAD logs the transcript reply"
done

echo ""
echo "=== req-004: the hook skips and never blocks ==="
P=$(new_project)
rm -f "$P/plan/.orchestrator-active"
run_hook "$P" "$TMP/b.jsonl" '"Plain reply"'
assert_equals "0" "$CODE" "req-004: no sentinel exits 0"
assert_equals "" "$OUT" "req-004: no sentinel prints nothing"
assert_equals "0" "$(log_lines "$P")" "req-004: no sentinel logs nothing"

P=$(new_project)
run_hook "$P" "$TMP/does-not-exist.jsonl"
assert_equals "0" "$CODE" "req-004: a missing transcript exits 0"
assert_equals "" "$OUT" "req-004: a missing transcript prints nothing"
OUT=$(printf '%s' '{not json' | node "$HOOK" 2>/dev/null); CODE=$?
assert_equals "0" "$CODE" "req-004: malformed JSON exits 0"

print_summary
