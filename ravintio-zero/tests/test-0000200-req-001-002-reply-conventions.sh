#!/usr/bin/env bash
# Tests for feature 0000200-reply-conventions, req-001 and req-002: the boot
# template holds the reply conventions, the orchestrator lists Supervise: and
# the reporting rule, and each phase skill opens with its own prefix line.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
BOOT="$ZERO_DIR/templates/standard-boot.md"
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"

RULE_LIST="results, deviations, failures, and decisions"
RULE_BAR="never states that the agent followed a standing rule"
STATUS_FORM='{prefix} {Status}: {one-liner}'

SECTION=$(awk '/^## Reply Conventions/{f=1;next} /^## /{f=0} f' "$BOOT")

echo ""
echo "=== req-001 AC-1: the boot file carries the table ==="
assert_contains "## Reply Conventions" "$(cat "$BOOT")" "req-001 AC-1: the boot file has a Reply Conventions section"
for p in 'P0 Discovery:' 'P1 Plan:' 'P2 Implement:' 'P3 Validate:' 'P4 Ship:' \
         'I-A Chart:' 'I-B Activate:' 'I-C Run:' 'I-D Advance:' 'I-E Delivery:' 'Supervise:'; do
  assert_contains "$p" "$SECTION" "req-001 AC-1: the section holds $p"
done
# The boot template renders into installed files, so it carries no anchors.
BOOT_TEXT="$(cat "$BOOT")"
assert_contains 'Supervise:' "$BOOT_TEXT" "req-001 AC-1: the boot file holds Supervise:"
assert_contains "$STATUS_FORM" "$BOOT_TEXT" "req-001 AC-1: the boot file holds the status form"
assert_contains "date +%H:%M" "$BOOT_TEXT" "req-001 AC-1: the boot file names the clock command"

echo ""
echo "=== req-001 AC-2: the reporting rule is stated twice ==="
assert_contains "$RULE_LIST" "$BOOT_TEXT" "req-001 AC-2: the boot file states the reporting rule list"
assert_contains "$RULE_BAR" "$BOOT_TEXT" "req-001 AC-2: the boot file states the reporting rule bar"
assert_rule orc-orch-reporting-rule "$RULE_LIST" "$RULE_BAR"

echo ""
echo "=== req-001 AC-3: the orchestrator lists Supervise: ==="
assert_rule orc-orch-supervise '`Supervise:`' "{Status}: {one-liner}"

echo ""
echo "=== req-002 AC-1: each phase skill states its prefix ==="
assert_rule orc-prefix-p1 'P1 Plan:' "$STATUS_FORM"
assert_rule orc-prefix-p2 'P2 Implement:' "$STATUS_FORM"
assert_rule orc-prefix-p3 'P3 Validate:' "$STATUS_FORM"
assert_rule orc-prefix-p4 'P4 Ship:' "$STATUS_FORM"

print_summary
