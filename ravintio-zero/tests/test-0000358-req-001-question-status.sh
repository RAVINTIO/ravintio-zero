#!/usr/bin/env bash
# Test: 0000358 req-001 question-status
# The status set names Question wherever it is listed, Blocked: stays for
# exception stops, and resume detection keeps reading Blocked: only.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REPO_ROOT="$ZERO_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
REFS="$ZERO_DIR/skills/ravintio-orchestrator/references"

echo ""
echo "=== req-001 AC-1: every status list names Question and Blocked ==="
assert_rule orc-orch-status-form "Question" "Blocked"
# The boot templates render into installed files, so they carry no anchors.
for boot in standard-boot codex-boot; do
  boot_status="$(grep -E "The status is " "$ZERO_DIR/templates/$boot.md" | head -1)"
  assert_contains "Question" "$boot_status" "req-001 AC-1: $boot lists Question"
  assert_contains "Blocked" "$boot_status" "req-001 AC-1: $boot lists Blocked"
done
assert_contains "Question" "$(grep -E 'The status is ' "$ZERO_DIR/pipeline-reference.md" | head -1)" "req-001 AC-1: pipeline-reference.md lists Question"
assert_contains "Blocked" "$(grep -E 'The status is ' "$ZERO_DIR/pipeline-reference.md" | head -1)" "req-001 AC-1: pipeline-reference.md still lists Blocked"
assert_contains "Question" "$(sed -n '1,40p' "$ZERO_DIR/hooks/enforcement/check-reply-prefix.mjs")" \
  "req-001 AC-1: the hook comment lists the status set with Question"

echo ""
echo "=== req-001 AC-2: Blocked is reserved for exception stops ==="
assert_rule orc-orch-question-status '`Question:`' "exception stop"
assert_rule p0-start-product-id "P0 Discovery: Question: No declared product id"
assert_equals "no" "$(rule_text p0-start-product-id | grep -qF 'P0 Discovery: Blocked: No declared product id' && echo yes || echo no)" \
  "req-001 AC-2: the product id check no longer uses Blocked:"

echo ""
echo "=== req-001 AC-3: resume detection reads Blocked only ==="
RES="$(cat "$REFS/orchestrator-resume-detection.md")"
assert_contains "Blocked" "$RES" "req-001 AC-3: resume detection names Blocked"
assert_not_contains "Question" "$RES" "req-001 AC-3: resume detection does not name Question"

print_summary
