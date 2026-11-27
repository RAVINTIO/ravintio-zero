#!/usr/bin/env bash
# Tests for feature 0000042-autonomous-mode-and-prefixes, req-011: exception
# stop records and redaction.
#
# Every exception stop appends a Blocked: line to the build log, and the human's
# answer adds a Resolved: line. Resume refuses to pass an unresolved stop.
# Acceptance evidence holds results and file:line cites only, and ship scans
# the PR body for credentials. A possible credential is a fifth exception stop.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
VAL="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"
FLOW="$ZERO_DIR/workflows/feature-pipeline.md"

STOPS="$(orch_section '## Exception Stops')"
SHIP_CONTENT="$(cat "$SHIP")"
CRED_MSG='Blocked: possible credential in {path}. Remove it or confirm it is not a secret.'

echo ""
echo "=== req-011 (a): exception stops leave a build-log record ==="

assert_rule stops-log-blocked 'Append `Blocked: {exception} ({ISO-8601 timestamp})` to the build log'
assert_rule stops-log-resolved 'append `Resolved: {exception} ({ISO-8601 timestamp}, {decision})`'
assert_rule resume-run-mode 'with no later `Resolved:` line' 'Do not move on in either mode.'

echo ""
echo "=== req-011 (b): evidence carries no raw output, and ship scans the PR body ==="

assert_rule piv-p3-autonomous-evidence 'never raw command output, environment values, or file contents' '`file:line` cites'
assert_rule orc-ship-pr-credential-scan 'scan the PR body for credential patterns'
assert_contains "P4 Ship: $CRED_MSG" "$SHIP_CONTENT" \
  "req-011 (b): a match in the PR body is a credential stop"

echo ""
echo "=== req-011 (c): a possible credential is a fifth exception stop ==="

assert_contains "$CRED_MSG" "$STOPS" \
  "req-011 (c): the Exception Stops table has a credential row"
assert_contains 'before the commit and before any push' "$STOPS" \
  "req-011 (c): the credential stop fires before the commit and any push"
assert_equals "6" "$(printf '%s\n' "$STOPS" | grep -cE '^\| .* \| `(\{prefix\}|P[0-4] [A-Za-z]+:) ?Blocked: ')" \
  "req-011 (c): the table has six exception rows (the sixth is the 0000151 dependency stop)"
for f in "$REF" "$FLOW"; do
  assert_contains 'possible credential' "$(cat "$f")" \
    "req-011 (c): $(basename "$f") lists the credential stop"
done

print_summary
