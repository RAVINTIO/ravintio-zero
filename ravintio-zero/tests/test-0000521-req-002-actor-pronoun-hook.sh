#!/usr/bin/env bash
# Tests for feature 0000521-replies-name-actors-by-role, REQ-002: the reply
# hook flags I and you in a run reply.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HOOK="$SCRIPT_DIR/../hooks/enforcement/check-reply-writing.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/.claude/output-styles"
: > "$TMP/.claude/output-styles/ravintio-writing.md"

run_hook() {
  local payload
  payload="$(node -e 'console.log(JSON.stringify({ hook_event_name: "Stop", cwd: process.argv[1], last_assistant_message: process.argv[2] }))' "$TMP" "$1")"
  OUT="$(printf '%s' "$payload" | node "$HOOK" 2>/dev/null)"
  CODE=$?
}

echo ""
echo "=== req-002 AC-1: a run reply with I or you gets a note ==="
run_hook "18:00 I-C Run: Complete: step done.

I fixed the test."
assert_equals "0" "$CODE" "req-002 AC-1: the hook exits 0"
assert_contains "actor-pronoun" "$OUT" "req-002 AC-1: the note names the rule"
run_hook "18:00 P2 Implement: Complete: step done.

The next move is up to you."
assert_contains "actor-pronoun" "$OUT" "req-002 AC-1: you gets a note"
run_hook "18:00 Supervise: Complete: step done.

Check your queue."
assert_contains "actor-pronoun" "$OUT" "req-002 AC-1: your gets a note"

echo ""
echo "=== req-002 AC-2: other replies get no note ==="
run_hook "Short reply, and you may read it."
assert_equals "" "$OUT" "req-002 AC-2: a reply with no run prefix gets no note"
run_hook "18:00 I-C Run: Complete: step done.

The agent fixed the test for the human."
assert_equals "" "$OUT" "req-002 AC-2: a reply that names roles gets no note"

echo ""
echo "=== req-002 AC-3: the prefix and code do not count ==="
run_hook "18:00 I-C Run: Complete: step done.

Run \`you fixed I\` in the shell.

> I wrote this line.

\`\`\`
you and I
\`\`\`"
assert_equals "" "$OUT" "req-002 AC-3: the prefix, code, and a quote get no note"

print_summary
