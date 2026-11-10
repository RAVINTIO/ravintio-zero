#!/usr/bin/env bash
# Tests for feature 0000468-reply-time-matches-the-clock, req-002: each place that
# states the reply form tells the step to read date +%H:%M before each reply.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

PACK="$SCRIPT_DIR/.."

echo ""
echo "=== req-002 AC-1: the rule text names the command ==="
for F in standards/roadmap-standards.md skills/ravintio-orchestrator/SKILL.md skills/ravintio-initiative/SKILL.md templates/standard-boot.md templates/codex-boot.md; do
  if grep -qF 'date +%H:%M' "$PACK/$F"; then
    assert_equals "ok" "ok" "req-002 AC-1: $F names date +%H:%M"
  else
    assert_equals "ok" "missing" "req-002 AC-1: $F names date +%H:%M"
  fi
done

echo ""
echo "=== req-002 AC-2: the enforcement reference states the margin ==="
REF="$PACK/standards/hook-enforcement.md"
assert_contains "5 minutes" "$(cat "$REF")" "req-002 AC-2: hook-enforcement.md names the margin"
assert_contains "RAVINTIO_REPLY_CLOCK" "$(cat "$REF")" "req-002 AC-2: hook-enforcement.md names the clock override"
assert_contains "RAVINTIO_REPLY_MARGIN_MIN" "$(cat "$REF")" "req-002 AC-2: hook-enforcement.md names the margin override"

print_summary
