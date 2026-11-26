#!/usr/bin/env bash
# Tests for feature 0000483-mergeability-before-ci-wait, req-002: the roadmap standards and the
# ship skill tell a step to read mergeability before it polls for checks.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."

echo "=== REQ-002 AC-1: I-D Advance reads mergeable before the first poll ==="
ADVANCE="$(orch_section "### I-D Advance")"
assert_rule rm-advance-mergeable 'gh pr view {n} --json mergeable'
READ_LINE="$(printf '%s\n' "$ADVANCE" | grep -n 'gh pr view {n} --json mergeable' | head -1 | cut -d: -f1)"
POLL_LINE="$(printf '%s\n' "$ADVANCE" | grep -n 'Poll `gh pr checks {n}`' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$READ_LINE" ] && [ -n "$POLL_LINE" ] && [ "$READ_LINE" -lt "$POLL_LINE" ] && echo yes || echo no)" \
  "AC-1: the read comes before the first poll"
assert_rule rm-advance-conflict-line 'I-D Advance: Blocked: PR #{n} conflicts with the initiative branch.'
assert_rule rm-mq-wait-ci 'MQ_NOCHECKS_MS'

echo "=== REQ-002 AC-2: the ship skill names the same read ==="
assert_rule shp-initiative-pr-number 'gh pr view {n} --json mergeable'

print_summary
