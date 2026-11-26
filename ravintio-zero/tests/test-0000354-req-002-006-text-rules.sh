#!/usr/bin/env bash
# Tests for feature 0000354-steps-run-to-the-end: req-002 (early-end rule), req-004 (one
# driver-arguments helper), and req-006 (the Step CI fixes field).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$(cat "$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md")"
TPL="$(cat "$ZERO_DIR/templates/initiative.template.md")"

echo ""
echo "=== req-002 AC-1: the orchestrator names the early-end rule ==="
assert_contains "never end your turn before" "$ORCH" "AC-1: the rule is present"
RULE="$(printf '%s\n' "$ORCH" | grep 'never end your turn before')"
assert_contains 'I-D Advance: Complete:' "$RULE" "AC-1: the rule names I-D Advance: Complete:"
assert_contains 'Blocked:' "$RULE" "AC-1: the rule names a Blocked: line"
assert_contains 'step session' "$RULE" "AC-1: the rule applies to a step session"

echo ""
echo "=== req-004 AC-1: the driver suites share one helper ==="
for t in test-0000043-req-007-roadmap-driver.sh test-0000151-req-006-roadmap-step-model-and-turn-cap.sh test-0000189-req-006-old-variable-stop.sh test-0000354-req-001-driver-resume.sh; do
  assert_equals "0" "$(grep -c -- '--permission-mode auto' "$SCRIPT_DIR/$t")" "AC-1: $t repeats no argument string"
  assert_contains "helpers/driver-args.sh" "$(cat "$SCRIPT_DIR/$t")" "AC-1: $t sources the helper"
done
assert_contains "--permission-mode auto" "$(cat "$SCRIPT_DIR/helpers/driver-args.sh")" "AC-1: the helper holds the arguments"

echo ""
echo "=== req-006 AC-1: the template holds the field ==="
assert_contains '**Step CI fixes:**' "$TPL" "AC-1: the template has the field"
FIELD="$(printf '%s\n' "$TPL" | grep -F '**Step CI fixes:**')"
assert_contains 'allowed' "$FIELD" "AC-1: the field names allowed"
assert_contains 'stop' "$FIELD" "AC-1: the field names stop"

echo ""
echo "=== req-006 AC-2: the standards state the rule ==="
assert_rule rm-advance-watch 'Step CI fixes' 'allowed' 'the default is `stop`'
assert_rule rm-driver-resume 'resume'
assert_rule rm-steplog-waiting 'waiting for the build log'

print_summary
