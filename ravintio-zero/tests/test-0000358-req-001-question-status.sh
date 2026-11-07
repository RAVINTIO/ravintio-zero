#!/usr/bin/env bash
# Test: 0000358 req-001 question-status
# The status set names Question wherever it is listed, Blocked: stays for
# exception stops, and resume detection keeps reading Blocked: only.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REPO_ROOT="$ZERO_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
REFS="$ZERO_DIR/skills/ravintio-orchestrator/references"

echo ""
echo "=== req-001 AC-1: every status list names Question and Blocked ==="
for f in \
  "$ORCH" \
  "$ZERO_DIR/pipeline-reference.md" \
  "$ZERO_DIR/templates/standard-boot.md" \
  "$ZERO_DIR/templates/codex-boot.md"; do
  LINE="$(grep -E 'The status is ' "$f" | head -1)"
  name="${f#"$REPO_ROOT"/}"
  assert_contains "Question" "$LINE" "req-001 AC-1: $name lists Question"
  assert_contains "Blocked" "$LINE" "req-001 AC-1: $name still lists Blocked"
done
assert_contains "Question" "$(sed -n '1,40p' "$ZERO_DIR/hooks/enforcement/check-reply-prefix.mjs")" \
  "req-001 AC-1: the hook comment lists the status set with Question"

echo ""
echo "=== req-001 AC-2: Blocked is reserved for exception stops ==="
ORCH_TEXT="$(cat "$ORCH")"
assert_contains '`Question:`' "$ORCH_TEXT" "req-001 AC-2: the orchestrator skill explains Question:"
assert_contains "exception stop" "$(grep -F '`Question:`' "$ORCH" | head -1)" \
  "req-001 AC-2: the Question line names the exception stop split"
assert_contains "P0 Discovery: Question: No declared product id" "$(cat "$REFS/orchestrator-p0-start-actions.md")" \
  "req-001 AC-2: the product id check asks with Question:"
assert_not_contains "P0 Discovery: Blocked: No declared product id" "$(cat "$REFS/orchestrator-p0-start-actions.md")" \
  "req-001 AC-2: the product id check no longer uses Blocked:"

echo ""
echo "=== req-001 AC-3: resume detection reads Blocked only ==="
RES="$(cat "$REFS/orchestrator-resume-detection.md")"
assert_contains "Blocked" "$RES" "req-001 AC-3: resume detection names Blocked"
assert_not_contains "Question" "$RES" "req-001 AC-3: resume detection does not name Question"

print_summary
