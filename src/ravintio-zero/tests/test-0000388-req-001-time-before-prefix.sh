#!/usr/bin/env bash
# Tests for feature 0000388-replies-and-questions, req-001: check-design injects
# the local time as hh:mm and check-reply-prefix accepts a leading hh:mm.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PREFIX_HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-prefix.mjs"
DESIGN_HOOK="$SCRIPT_DIR/../hooks/enforcement/check-design.mjs"

TMP=$(mktemp -d -t ravintio_0000388_req001_XXXXXX)
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

run_prefix() {
  local payload
  payload=$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], transcript_path: process.argv[2] }))' "$1" "$2")
  # A margin of 720 minutes accepts any time, so this suite tests the shape only.
  OUT=$(printf '%s' "$payload" | env -u RAVINTIO_INITIATIVE_STEP RAVINTIO_REPLY_MARGIN_MIN=720 node "$PREFIX_HOOK" 2>/dev/null)
  CODE=$?
}

run_design() {
  OUT=$(printf '{"hook_event_name":"UserPromptSubmit","cwd":"%s"}' "$1" | node "$DESIGN_HOOK" 2>/dev/null)
  CODE=$?
}

assert_matches() {
  if printf '%s' "$2" | grep -Eq "$1"; then assert_equals "ok" "ok" "$3"; else assert_equals "ok" "no match: $1" "$3"; fi
}

LOG_REL="plan/.prefix-misses.log"
log_lines() { if [ -f "$1/$LOG_REL" ]; then wc -l < "$1/$LOG_REL" | tr -d ' '; else echo 0; fi; }

echo ""
echo "=== req-001 AC-1: a leading time is accepted ==="
P=$(new_project)
for TXT in "06:43 I-C Run: Starting: x" "06:43 P0 Discovery: Starting: x" "23:59 Supervise: Complete: y"; do
  write_transcript "$TMP/t.jsonl" "$TXT"
  run_prefix "$P" "$TMP/t.jsonl"
  assert_equals "0" "$CODE" "req-001 AC-1: '$TXT' exits 0"
  assert_equals "" "$OUT" "req-001 AC-1: '$TXT' prints nothing"
done
assert_equals "0" "$(log_lines "$P")" "req-001 AC-1: no miss is logged"

echo ""
echo "=== req-001 AC-2: a missing prefix is still logged ==="
P=$(new_project)
write_transcript "$TMP/t.jsonl" "Plain reply with no prefix"
run_prefix "$P" "$TMP/t.jsonl"
assert_equals "0" "$CODE" "req-001 AC-2: no prefix exits 0"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-2: no prefix warns"
assert_equals "1" "$(log_lines "$P")" "req-001 AC-2: no prefix logs one line"
write_transcript "$TMP/t.jsonl" "06:43 Plain reply with a time only"
run_prefix "$P" "$TMP/t.jsonl"
assert_contains '"systemMessage"' "$OUT" "req-001 AC-2: a time with no prefix warns"
assert_equals "2" "$(log_lines "$P")" "req-001 AC-2: a time with no prefix logs a line"

echo ""
echo "=== req-001 AC-3: check-design injects the time ==="
P=$(new_project)
: > "$P/plan/current/feature-brief.md"
printf '# Design\n\n## Scope\n\n- src/a\n' > "$P/plan/current/design.md"
run_design "$P"
assert_equals "0" "$CODE" "req-001 AC-3: the hook exits 0"
CTX=$(node -e 'process.stdout.write(JSON.parse(process.argv[1]).additionalContext)' "$OUT" 2>/dev/null)
if [[ "$CTX" =~ Local\ time:\ ([0-2][0-9]):([0-5][0-9]) ]]; then
  assert_equals "ok" "ok" "req-001 AC-3: additionalContext holds hh:mm"
else
  assert_equals "ok" "missing" "req-001 AC-3: additionalContext holds hh:mm"
fi
assert_contains "Confirmed scope" "$CTX" "req-001 AC-3: the scope stays in the context"

P=$(new_project)
: > "$P/plan/current/feature-brief.md"
run_design "$P"
assert_equals "0" "$CODE" "req-001 AC-3: no design exits 0"
assert_matches 'Local time: [0-2][0-9]:[0-5][0-9]' "$OUT" "req-001 AC-3: the time appears when the design is absent"

printf '# Design\n\nNo scope heading.\n' > "$P/plan/current/design.md"
run_design "$P"
assert_matches 'Local time: [0-2][0-9]:[0-5][0-9]' "$OUT" "req-001 AC-3: the time appears when the scope is empty"

P=$(new_project)
rm -f "$P/plan/.orchestrator-active"
run_design "$P"
assert_equals "0" "$CODE" "req-001 AC-3: the stop branch exits 0"
assert_matches 'Local time: [0-2][0-9]:[0-5][0-9]' "$OUT" "req-001 AC-3: the time appears in the stop branch"

print_summary
