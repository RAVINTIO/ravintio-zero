#!/usr/bin/env bash
# Test: 0000489 req-001 Question asks the human something
# The standards, the orchestrator skill, and the pipeline reference say that Question: asks
# the human a question and that a step waiting on its own work keeps working.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
RULE=$(grep 'rule: icrun-question-real' "$ZERO_DIR/standards/roadmap-standards.md")
QLINE=$(grep -F '`Question:`' "$ORCH" | head -1)
PLINE=$(grep -F 'Question: `P0 Discovery: Question:' "$ZERO_DIR/pipeline-reference.md" | head -1)

echo ""
echo "=== req-001 AC-1: the standards state the rule ==="
assert_contains "question mark" "$RULE" "req-001 AC-1: the rule names the question mark"
assert_contains "keeps working" "$RULE" "req-001 AC-1: a waiting step keeps working"
assert_contains "wakeup" "$RULE" "req-001 AC-1: the rule names the wakeup"

echo ""
echo "=== req-001 AC-2: the status text says Question asks the human ==="
assert_contains "asks the human" "$QLINE" "req-001 AC-2: SKILL.md says Question asks the human"
assert_contains "exception stop" "$QLINE" "req-001 AC-2: SKILL.md keeps the exception stop split"
assert_contains "asks the human" "$PLINE" "req-001 AC-2: pipeline-reference.md says Question asks the human"

echo ""
echo "=== req-001 AC-3: the caps hold ==="
BYTES=$(wc -c < "$ORCH" | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-3: orchestrator $BYTES <= 9000 bytes"
TOTAL=$(find "$ZERO_DIR/skills" -name "SKILL.md" -exec cat {} + | wc -l | tr -d ' ')
assert_equals "yes" "$([ "$TOTAL" -le 1720 ] && echo yes || echo no)" "req-001 AC-3: skill text $TOTAL <= 1720"

print_summary
