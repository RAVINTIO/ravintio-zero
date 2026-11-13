#!/usr/bin/env bash
# Tests for feature 0000483-mergeability-before-ci-wait, req-002: the roadmap standards and the
# ship skill tell a step to read mergeability before it polls for checks.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."
STANDARDS="$(cat "$PACK/standards/roadmap-standards.md")"
SHIP="$(cat "$PACK/skills/ravintio-ship/SKILL.md")"

echo "=== REQ-002 AC-1: I-D Advance reads mergeable before the first poll ==="
ADVANCE="$(printf '%s\n' "$STANDARDS" | awk '/^### I-D Advance/{f=1} /^### I-E Delivery/{f=0} f')"
assert_contains 'gh pr view {n} --json mergeable' "$ADVANCE" "AC-1: I-D Advance names the mergeable read"
READ_LINE="$(printf '%s\n' "$ADVANCE" | grep -n 'gh pr view {n} --json mergeable' | head -1 | cut -d: -f1)"
POLL_LINE="$(printf '%s\n' "$ADVANCE" | grep -n 'Poll `gh pr checks {n}`' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$READ_LINE" ] && [ -n "$POLL_LINE" ] && [ "$READ_LINE" -lt "$POLL_LINE" ] && echo yes || echo no)" \
  "AC-1: the read comes before the first poll"
assert_contains 'I-D Advance: Blocked: PR #{n} conflicts with the initiative branch.' "$ADVANCE" "AC-1: the conflict stop is named"
assert_contains 'MQ_NOCHECKS_MS' "$STANDARDS" "AC-1: the merge queue section names the no-checks limit"

echo "=== REQ-002 AC-2: the ship skill names the same read ==="
assert_contains 'gh pr view {n} --json mergeable' "$SHIP" "AC-2: the ship skill names the mergeable read"

print_summary
