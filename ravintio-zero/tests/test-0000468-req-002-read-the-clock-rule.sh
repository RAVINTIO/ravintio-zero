#!/usr/bin/env bash
# Tests for feature 0000468-reply-time-matches-the-clock, req-002: each place that
# states the reply form tells the step to read date +%H:%M before each reply.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."

echo ""
echo "=== req-002 AC-1: the rule text names the command ==="
assert_rule reply-time-form 'date +%H:%M'
assert_rule rm-ini-prefix 'date +%H:%M'
for F in skills/ravintio-orchestrator/SKILL.md templates/standard-boot.md templates/codex-boot.md; do
  if grep -qF 'date +%H:%M' "$PACK/$F"; then
    assert_equals "ok" "ok" "req-002 AC-1: $F names date +%H:%M"
  else
    assert_equals "ok" "missing" "req-002 AC-1: $F names date +%H:%M"
  fi
done

echo ""
echo "=== req-002 AC-2: the enforcement reference states the margin ==="
assert_rule ob-hook-check-reply-prefix "2 minutes" "RAVINTIO_REPLY_CLOCK" "RAVINTIO_REPLY_MARGIN_MIN"

print_summary
