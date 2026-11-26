#!/usr/bin/env bash
# Test: 0000489 req-001 Question asks the human something
# The standards, the orchestrator skill, and the pipeline reference say that Question: asks
# the human a question and that a step waiting on its own work keeps working.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
PLINE=$(grep -F 'Question: `P0 Discovery: Question:' "$ZERO_DIR/pipeline-reference.md" | head -1)

echo ""
echo "=== req-001 AC-1: the standards state the rule ==="
assert_rule icrun-question-real "question mark" "keeps working" "wakeup"

echo ""
echo "=== req-001 AC-2: the status text says Question asks the human ==="
assert_rule orc-orch-question-status "asks the human" "exception stop"
assert_contains "asks the human" "$PLINE" "req-001 AC-2: pipeline-reference.md says Question asks the human"

echo ""
echo "=== req-001 AC-3: the caps hold ==="
BYTES=$(strip_rule_anchors < "$ORCH" | wc -c | tr -d ' ')  # anchors are comments, so the cap measures the text without them
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator $BYTES <= 9000 bytes"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-001 AC-3: skill text $TOTAL <= 1720"

print_summary
