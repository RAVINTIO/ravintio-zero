#!/usr/bin/env bash
# Tests for feature 0000032-relocate-setup-config-to-plan-state, req-004
# (refresh-setup-reads-record-first).
#
# ravintio-refresh-setup is a Markdown skill followed by an agent, not
# executable code, so coverage is structural: grep-based assertions over
# SKILL.md, matching the established pattern in
# test-0000020-req-001-010-refresh-setup-skill.sh.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="$ZERO_DIR/skills/ravintio-refresh-setup/SKILL.md"

assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" \
  "req-004: ravintio-refresh-setup/SKILL.md exists"

echo ""
echo "=== req-004: Step 3 reads the record first, at high confidence ==="

assert_rule oa-refresh-record-first 'plan/state/{tool}.md'
assert_rule oa-refresh-record-valid "high" "Do not consult the marker file"

echo ""
echo "=== req-004: record validation rules ==="

assert_rule oa-refresh-record-json '```json'
assert_rule oa-refresh-record-fields "tool" "flags" 'all three fields: `tool`, `flags`, `writtenAt`' "writtenAt"
assert_rule oa-refresh-record-tool "matches the target"

echo ""
echo "=== req-004: fallback order and no-stop behaviour ==="

assert_rule oa-refresh-marker-second "marker"
assert_rule oa-refresh-hook-infer "hook"
assert_rule oa-refresh-record-invalid "does not stop the run"

echo ""
echo "=== req-004: Step 4 names the source per flag ==="

assert_rule oa-refresh-confirm-sources "the record" "marker" "inferred"

echo ""
echo "=== req-004: Step 2's interrupted-run detection is unchanged ==="

assert_rule oa-refresh-interrupted 'attemptStatus: "pending"'

echo ""
echo "=== req-004: the record's values are validated, not just its shape ==="

assert_not_contains "--structured-telemetry-mcp" "$(rule_text oa-refresh-allowed-flags)" \
  "req-004: the allowed set no longer holds the removed flag --structured-telemetry-mcp"
assert_rule oa-refresh-allowed-flags "--strict-orchestrator" "allowed set"
assert_rule oa-refresh-record-values "shell metacharacter"

print_summary
