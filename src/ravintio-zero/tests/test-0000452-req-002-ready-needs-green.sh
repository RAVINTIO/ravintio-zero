#!/usr/bin/env bash
# Tests for feature 0000452-ci-wait-before-archive, req-002: a step writes
# ready only when every check on the PR head passed.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
adv="$(orch_section "### I-D Advance")"

echo ""
echo "=== req-002 AC-1: no ready on a pending or failed check ==="
assert_rule rm-advance-ready 'exits 0' 'pending' 'Never write `ready`'
assert_rule rm-advance-ci-failed 'I-D Advance: Blocked: CI failed on PR #{n}'

echo ""
echo "=== req-002 AC-2: a second wait follows the closing push ==="
waits="$(printf '%s\n' "$adv" | grep -c 'gh pr checks {n} --watch --fail-fast')"
assert_equals "yes" "$([ "$waits" -ge 2 ] && echo yes || echo no)" "req-002 AC-2: the stage watches the checks twice"
push="$(printf '%s\n' "$adv" | grep -n 'closing push' | head -1 | cut -d: -f1)"
w2="$(printf '%s\n' "$adv" | grep -n 'gh pr checks {n} --watch --fail-fast' | tail -1 | cut -d: -f1)"
rdy="$(printf '%s\n' "$adv" | grep -n 'RAVINTIO_INITIATIVE_CONTROL/ready' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$push" ] && [ -n "$w2" ] && [ -n "$rdy" ] && [ "$push" -lt "$w2" ] && [ "$w2" -lt "$rdy" ] && echo yes || echo no)" "req-002 AC-2: closing push, second wait, then ready"

echo ""
echo "=== req-002 AC-3: the ship skill states the rule ==="
assert_rule rm-ship-initiative-ready 'only after every check'

print_summary
