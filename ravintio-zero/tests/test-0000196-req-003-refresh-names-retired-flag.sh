#!/usr/bin/env bash
# Tests for feature 0000196-setup-argument-checks, req-003: the refresh skill
# names a retired flag that a record or marker holds, and leaves it out of the
# command it proposes. ravintio-refresh-setup is a Markdown skill followed by
# an agent, so coverage is structural, as in
# test-0000032-req-004-refresh-setup-reads-record-first.sh.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="$ZERO_DIR/skills/ravintio-refresh-setup/SKILL.md"

assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" \
  "req-003: ravintio-refresh-setup/SKILL.md exists"

echo ""
echo "=== req-003 AC-1: a record that holds a retired flag is reported ==="

assert_rule oa-refresh-retired-flags "retired flag" --structured-telemetry-mcp --context-mode-mcp --include-full-skill-library --backend-url "setup rejects"
assert_rule oa-refresh-retired-record "plan/state/{tool}.md" "setup rejects"

echo ""
echo "=== req-003 AC-2: a marker that holds a retired flag is reported ==="

assert_rule oa-refresh-retired-marker ".ravintio-setup-flags"

echo ""
echo "=== req-003 AC-3: the proposed command omits the retired flag ==="

assert_rule oa-refresh-retired-record "Omit"
assert_rule oa-refresh-retired-marker "omit"
assert_rule oa-refresh-retired-never "Never put a retired flag in the command"
assert_equals "0" "$(grep -c -- 'setup.sh claude-code .*--backend-url' "$SKILL" || true)" \
  "req-003 AC-3: the skill never builds a command with a retired flag"

print_summary
