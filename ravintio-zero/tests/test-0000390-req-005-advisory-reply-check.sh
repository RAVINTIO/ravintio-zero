#!/usr/bin/env bash
# Tests for feature 0000390-prose-checks, REQ-005: the advisory reply check.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-writing.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# new_project STYLE: make a project dir. STYLE "yes" adds the output style file.
new_project() {
  local d
  d="$(mktemp -d "$TMP/proj_XXXXXX")"
  if [ "$1" = "yes" ]; then
    mkdir -p "$d/.claude/output-styles"
    : > "$d/.claude/output-styles/ravintio-writing.md"
  fi
  echo "$d"
}

# run_hook CWD REPLY: feed a Stop payload with last_assistant_message.
run_hook() {
  local payload
  payload="$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], last_assistant_message: process.argv[2] }))' "$1" "$2")"
  OUT="$(printf '%s' "$payload" | node "$HOOK" 2>/dev/null)"
  CODE=$?
}

LONG="Alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu again and more words."

echo ""
echo "=== AC-1: a long sentence produces a note ==="
P="$(new_project yes)"
run_hook "$P" "$LONG"
assert_equals "0" "$CODE" "AC-1: the hook exits 0"
assert_contains '"systemMessage"' "$OUT" "AC-1: the output carries a systemMessage"
assert_contains "Reply writing check" "$OUT" "AC-1: the note names the check"
assert_contains "Alpha bravo charlie delta echo foxtrot g" "$OUT" "AC-1: the note quotes the first 40 characters"
assert_contains "sentence-length" "$OUT" "AC-1: the note names the rule"
assert_contains "advisory" "$OUT" "AC-1: the note says it is advisory"

echo ""
echo "=== AC-1: a blocklist word produces a note ==="
run_hook "$P" "This change is simple to review."
assert_contains "blocklist" "$OUT" "AC-1: the blocklist rule fires"

echo ""
echo "=== AC-1: the note shows at most 3 sentences ==="
run_hook "$P" "$LONG

$LONG

$LONG

$LONG"
COUNT="$(printf '%s' "$OUT" | grep -o "Alpha bravo" | wc -l | tr -d ' ')"
assert_equals "3" "$COUNT" "AC-1: four breaches show three quotes"

echo ""
echo "=== AC-1: the transcript supplies the reply when the field is absent ==="
node -e '
  const fs = require("node:fs");
  const [file, text] = process.argv.slice(1);
  fs.writeFileSync(file, [
    JSON.stringify({ type: "user", message: { role: "user", content: "hi" } }),
    JSON.stringify({ type: "assistant", message: { role: "assistant", content: [{ type: "text", text }] } }),
  ].join("\n") + "\n");
' "$TMP/t.jsonl" "$LONG"
OUT="$(node -e 'console.log(JSON.stringify({ cwd: process.argv[1], transcript_path: process.argv[2] }))' "$P" "$TMP/t.jsonl" | node "$HOOK" 2>/dev/null)"
assert_contains "sentence-length" "$OUT" "AC-1: the hook reads the last assistant text"

echo ""
echo "=== AC-2: the hook always exits 0 and a clean reply prints nothing ==="
run_hook "$P" "Short and clean."
assert_equals "0" "$CODE" "AC-2: a clean reply exits 0"
assert_equals "" "$OUT" "AC-2: a clean reply prints nothing"
OUT="$(printf 'not json' | node "$HOOK" 2>/dev/null)"; CODE=$?
assert_equals "0" "$CODE" "AC-2: bad JSON exits 0"
assert_equals "" "$OUT" "AC-2: bad JSON prints nothing"
OUT="$(printf '{}' | node "$HOOK" 2>/dev/null)"; CODE=$?
assert_equals "0" "$CODE" "AC-2: an empty payload exits 0"
OUT="$(printf '' | node "$HOOK" 2>/dev/null)"; CODE=$?
assert_equals "0" "$CODE" "AC-2: no input exits 0"

echo ""
echo "=== gate: no output style file, no note ==="
Q="$(new_project no)"
run_hook "$Q" "$LONG"
assert_equals "0" "$CODE" "gate: the hook exits 0 without the style file"
assert_equals "" "$OUT" "gate: the hook prints nothing without the style file"

print_summary
