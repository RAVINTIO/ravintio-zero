#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-009: resume detection and R- prefixes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
REF="$ZERO_DIR/pipeline-reference.md"

# The section from a heading to the next "---" rule.
section() { awk -v h="$1" '$0 == h {on=1; next} on && /^---$/ {exit} on {print}' "$2"; }
ORCH_SEC="$(orch_section '## Phases and Response Prefixes')"
REF_SEC="$(section '## Phase Indicators' "$REF")"

echo "=== req-009 (a): resume detection ==="
assert_rule resume-initiative 'plan/current-initiative/' 'Check `plan/current-initiative/` first' \
  'With `plan/current/` artifacts, resume that step' \
  'with `plan/current/` empty starts the step at `position`' \
  'load `ravintio-initiative` and stop'

echo ""
echo "=== req-009 (b): prefix tables ==="
# 0000244 moved the I-A to I-E prefix block from the orchestrator to the roadmap standards.
STD_PREFIX="$(rule_text rm-stages-table)"$'\n'"$(rule_text rm-stage-prefix-form)"$'\n'"$(rule_text rm-prefix-examples)"
for label in orchestrator pipeline-reference; do
  if [ "$label" = orchestrator ]; then SEC="$ORCH_SEC"$'\n'"$STD_PREFIX"; else SEC="$REF_SEC"; fi
  for p in 'I-A Chart:' 'I-B Activate:' 'I-C Run:' 'I-D Advance:' 'I-E Delivery:'; do
    assert_contains "\`$p\`" "$SEC" "req-009 (b): $label lists \`$p\`"
  done
  assert_contains '`{prefix} {Status}: {one-liner}`' "$SEC" "req-009 (b): $label states the status form"
  assert_contains 'stage letters, not phase numbers' "$SEC" "req-009 (b): $label says I-A to I-E are stage letters"
  assert_contains '`I-C Run: Starting: ' "$SEC" "req-009 (b): $label shows an R- status in the colon form"
done

echo ""
echo "=== req-009 (c): Hard Limit 10 unchanged ==="
assert_rule orc-hard-limit-phases 'The pipeline has exactly five phases, P0 to P4.'
for t in test-0000042-req-004-phase-numbers-p0-to-p4.sh test-0000042-req-005-message-prefixes.sh test-0000042-req-006-phase-guard-and-stale-cites.sh; do
  bash "$SCRIPT_DIR/$t" >/dev/null 2>&1
  assert_equals "0" "$?" "req-009 (c): $t passes"
done

print_summary
