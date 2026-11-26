#!/usr/bin/env bash
# Tests for feature 0000042-autonomous-mode-and-prefixes, req-002: gate and
# exception stops.
#
# A gated run stops at the P1, P2, P3, and P4 gates. An autonomous run stops at
# none of them. P3 puts its acceptance evidence in the PR description, and P4
# raises the PR and ends with "P4 Ship: Complete: PR #{n} ready for your
# review". Both modes stop on four exceptions with a Blocked: message that names
# the action needed. Work is committed and pushed, and the run resumes in the
# same mode. The agent never merges a PR or commits to main.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
VAL="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"

VAL_CONTENT="$(cat "$VAL")"
SHIP_CONTENT="$(cat "$SHIP")"
ORCH_CONTENT="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
ORCH_CONTENT="$(cat "$ORCH_CONTENT")"

has() { printf '%s\n' "$2" | grep -qF -- "$1" && echo yes || echo no; }

TABLE="$(orch_section '## Phase Invocation (P1 to P4)')"
STOPS="$(orch_section '## Exception Stops')"

COMPLETE='P4 Ship: Complete: PR #{n} ready for your review'

echo ""
echo "=== req-002 (a): gated stops at each of the P1 to P4 gates ==="

for row in '| P1 Plan |' '| P2 Implement |' '| P3 Validate and Accept |' '| P4 Ship |'; do
  line="$(printf '%s\n' "$TABLE" | grep -F -- "$row")"
  assert_contains "Gated: STOP" "$line" "req-002 (a): orchestrator row $row stops in gated"
done
assert_rule orc-p3-gate-gated 'In `gated`, this gate stops for the human.'
assert_rule orc-ship-pr-gated 'In `gated`, ask the human'
assert_rule orc-ship-final-gated 'In `gated`, this gate stops.'

echo ""
echo "=== req-002 (b): autonomous stops at none of the gates ==="

for row in '| P1 Plan |' '| P2 Implement |' '| P3 Validate and Accept |' '| P4 Ship |'; do
  line="$(printf '%s\n' "$TABLE" | grep -F -- "$row")"
  assert_contains "Autonomous: no stop." "$line" "req-002 (b): orchestrator row $row does not stop in autonomous"
done
assert_rule piv-p3-autonomous-evidence 'In `autonomous`, do not stop.' 'PR description'
assert_rule shp-pr-title-body '## Acceptance evidence'
assert_rule orc-ship-pr-autonomous 'In `autonomous`, take option [1] without asking.'
assert_rule orc-ship-final-autonomous 'In `autonomous`, print the same summary' 'end the run with this line'
assert_contains "$COMPLETE" "$SHIP_CONTENT" \
  "req-002 (b): ship ends with the PR-ready message in autonomous"
assert_equals "no" "$(has 'ALWAYS stops' "$VAL_CONTENT")" \
  "req-002 (b): validate-and-accept no longer says the gate always stops"
assert_equals "no" "$(has 'The final gate always stops.' "$SHIP_CONTENT")" \
  "req-002 (b): ship no longer says the final gate always stops"
assert_equals "no" "$(has "without the human's awareness" "$SHIP_CONTENT")" \
  "req-002 (b): ship no longer bars a PR without the human's awareness"
assert_rule shp-hard-limit-merge 'Merging into `main` stays human-only in every run mode, and the agent never commits to `main`.'
assert_equals "no" "$(has 'SHIP:' "$SHIP_CONTENT")" \
  "req-002 (b): ship uses the P4 Ship: prefix"

echo ""
echo "=== req-002 (c): both modes stop on four exceptions with Blocked: ==="

assert_rule stops-both-modes 'Both run modes stop on these exceptions.' 'Commit all work and push it before the stop'
assert_contains 'Both run modes stop on these exceptions.' "$STOPS" \
  "req-002 (c): the orchestrator lists the exception stops for both modes"
assert_contains 'still fails after 5 attempts' "$STOPS" "req-002 (c): stop on 5 failed attempts"
assert_contains 'schema change' "$STOPS" "req-002 (c): stop on a schema change"
assert_contains 'unmitigated critical or high' "$STOPS" "req-002 (c): stop on an unmitigated critical or high finding"
assert_contains '`gh pr create` fails' "$STOPS" "req-002 (c): stop on a failed push or gh pr create"
assert_equals "4" "$(printf '%s\n' "$STOPS" | grep -cE '^\| .* \| `P[0-4] [A-Za-z]+: Blocked: ')" \
  "req-002 (c): each of the four exceptions has a Blocked: message"
assert_contains 'Commit all work and push it before the stop' "$STOPS" \
  "req-002 (c): work is committed and pushed before the stop"
assert_contains 'the run resumes in the same mode' "$STOPS" \
  "req-002 (c): the run resumes in the same mode"
assert_equals "no" "$(has 'never blocks the pipeline' "$ORCH_CONTENT")" \
  "req-002 (c): a failed push is no longer passed over"

assert_contains 'P3 Validate: Blocked: {check} still fails after 5 attempts' "$VAL_CONTENT" \
  "req-002 (c): validate-and-accept escalates 5 failed cycles with Blocked:"
assert_contains 'P3 Validate: Blocked: {n} unmitigated critical or high' "$VAL_CONTENT" \
  "req-002 (c): validate-and-accept stops on an unmitigated critical or high finding"
assert_contains 'P4 Ship: Blocked: {command} failed' "$SHIP_CONTENT" \
  "req-002 (c): ship stops on a failed push or gh pr create"

print_summary
