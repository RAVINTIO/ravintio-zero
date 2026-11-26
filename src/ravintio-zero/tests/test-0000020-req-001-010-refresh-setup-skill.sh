#!/usr/bin/env bash
# Tests for feature 0000020-setup-refresh-skill, req-001 through req-007,
# req-009, req-010 (req-008 has its own live-invocation suite:
# test-0000020-req-008-install-time-marker-write.sh).
#
# These requirements are instructional skill content (ravintio-refresh-setup
# is a Markdown skill followed by the agent, not executable code), so
# semantic coverage is structural: grep-based assertions over SKILL.md,
# matching the established pattern for skill-content requirements in this
# repo (see test-0000018-req-003-orchestrator-marker-check-and-prompt.sh).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL="$ZERO_DIR/skills/ravintio-refresh-setup/SKILL.md"

assert_equals "yes" "$([ -f "$SKILL" ] && echo yes || echo no)" \
  "ravintio-refresh-setup/SKILL.md exists"

echo ""
echo "=== req-001: tool input and detection ==="

assert_rule oa-refresh-tool-input "always explicit input, never silently guessed"
assert_rule oa-refresh-install-found "Install found: proceed"

echo ""
echo "=== req-002: flag reconstruction with confidence ==="

assert_rule oa-refresh-record-valid "high"
assert_rule oa-refresh-signal-table "No signal present for a given flag" "plan/.orchestrator-strict\` file exists"

echo ""
echo "=== req-003: mandatory human confirmation gate ==="

assert_rule oa-refresh-confirm-always "Always required, in every run, regardless of confidence level" "There is no bypass."
assert_rule oa-refresh-confirm-reject "halt and take no further action"

echo ""
echo "=== req-004: safe boot-file deletion ==="

assert_rule oa-refresh-delete-script "refresh-delete-boot-files.sh"
assert_rule oa-refresh-delete-allowlist "cannot be told to delete anything else" "Never delete \`settings.local.json\`"

echo ""
echo "=== req-005: re-invoke setup with confirmed flags ==="

assert_rule oa-refresh-reinvoke "Run the exact command shown and confirmed in Step 4"
assert_rule oa-refresh-build-command "or \`setup.ps1 {tool} {flags...}\` on Windows"

echo ""
echo "=== req-006: setup failure handling ==="

assert_rule oa-refresh-no-retry "Do not retry automatically, under any condition"
assert_rule oa-refresh-investigate "Investigate the likely cause"
assert_rule oa-refresh-report "exact attempted command as a copyable code block"
assert_rule oa-refresh-marker-pending "attemptStatus"

echo ""
echo "=== req-007: no install found handling ==="

assert_rule oa-refresh-no-install "No RAVINTIO install found"
assert_rule oa-refresh-no-install-halt "Do not proceed to Step 2."

echo ""
echo "=== req-009: marker write before deletion ==="

assert_rule oa-refresh-marker-before "before Step 6's deletion" 'attemptStatus: "pending"'
assert_rule oa-refresh-marker-same-file "not a separate cache file"

echo ""
echo "=== req-010: cross-session recovery ==="

assert_contains "Check for an Interrupted Prior Run" "$(grep '^## Step 2' "$SKILL")" \
  "req-010: dedicated recovery-detection step exists"
assert_rule oa-refresh-interrupted 'attemptStatus: "pending"' "skipping Step 3" "If either is false, this is a normal run"

echo ""
echo "=== Cross-cutting: hardcoded allowlist and no-retry invariants restated ==="

assert_rule oa-refresh-never-delete "Never deletes any file other than \`CLAUDE.md\`/\`AGENTS.md\`"
assert_rule oa-refresh-never-retry "Never retries a failed setup re-invocation automatically"
assert_rule oa-refresh-never-bypass "Never proceeds past Step 4 without an explicit human affirmative"

print_summary
