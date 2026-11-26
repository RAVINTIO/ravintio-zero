#!/usr/bin/env bash
# test-0000010-pack-quality-improvements.sh
# Acceptance tests for feature 0000010
# Run from repo root: bash ravintio-zero/tests/test-0000010-pack-quality-improvements.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$SCRIPT_DIR/.."

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

TEMPLATE="$ZERO_DIR/templates/requirement.template.md"
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
CODEGEN="$ZERO_DIR/skills/ravintio-implement/SKILL.md"
VALIDATE="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"
SETUP_SH="$ZERO_DIR/setup.sh"
SETUP_PS1="$ZERO_DIR/setup.ps1"

echo ""
echo "=== REQ-001: Input Validation section in requirement.template.md ==="
if grep -q "## Input Validation" "$TEMPLATE"; then
  pass "REQ-001: template contains ## Input Validation section"
else
  fail "REQ-001: template missing ## Input Validation section"
fi

if grep -q "conditional\|only required\|only include" "$TEMPLATE"; then
  pass "REQ-001: template marks Input Validation as conditional"
else
  fail "REQ-001: template does not mark Input Validation as conditional"
fi

if grep -q "allowed character\|allowed chars\|character set\|\[a-z\]\|pattern" "$TEMPLATE"; then
  pass "REQ-001: template contains allowed character pattern placeholder"
else
  fail "REQ-001: template missing allowed character pattern placeholder"
fi

if grep -q "max.*length\|maximum.*length\|max.*chars\|length.*max" "$TEMPLATE"; then
  pass "REQ-001: template contains max length placeholder"
else
  fail "REQ-001: template missing max length placeholder"
fi

if grep -q "failure.*behav\|on.*failure\|fallback\|default.*value" "$TEMPLATE"; then
  pass "REQ-001: template contains failure behaviour placeholder"
else
  fail "REQ-001: template missing failure behaviour placeholder"
fi

existing_sections=$(grep -c "^## " "$TEMPLATE" 2>/dev/null || echo 0)
if grep -q "^## Functional Requirements" "$TEMPLATE" && grep -q "^## Acceptance Criteria" "$TEMPLATE"; then
  pass "REQ-001: existing Functional Requirements and Acceptance Criteria sections unchanged"
else
  fail "REQ-001: existing required sections missing or renamed"
fi

echo ""
echo "=== REQ-002: Agent tool in setup.sh ==="
if grep -q "Agent\|allowedTools" "$SETUP_SH"; then
  pass "REQ-002: setup.sh references Agent/allowedTools"
else
  fail "REQ-002: setup.sh does not reference Agent or allowedTools"
fi

if grep -q '"Agent"' "$SETUP_SH"; then
  pass "REQ-002: setup.sh contains \"Agent\" string for allowedTools"
else
  fail "REQ-002: setup.sh missing \"Agent\" in allowedTools"
fi

echo ""
echo "=== REQ-002: Agent tool in setup.ps1 ==="
if grep -q '"Agent"\|allowedTools' "$SETUP_PS1"; then
  pass "REQ-002: setup.ps1 references Agent allowedTools"
else
  fail "REQ-002: setup.ps1 does not reference Agent allowedTools"
fi

echo ""
echo "=== REQ-002: Agent dispatch template in orchestrator SKILL.md ==="
assert_rule orc-dispatch-self-contained "Self-contained prompt rule" "requirement file path"
assert_rule orc-dispatch-level-two "level-2 parallelism" "level-1" "native tool calls"
assert_rule orc-orch-consult-dispatch "agent-dispatch-standards"

DISPATCH_STD="$ZERO_DIR/standards/agent-dispatch-standards.md"
if grep -q "Agent Dispatch Template\|## Agent Dispatch" "$DISPATCH_STD"; then
  pass "REQ-002: dispatch standards hold the Agent Dispatch Template section"
else
  fail "REQ-002: dispatch standards missing Agent Dispatch Template section"
fi

echo ""
echo "=== REQ-002: Parallel Dispatch Checklist in codegen-agent SKILL.md ==="
if grep -qi "## Parallel dispatch" "$CODEGEN"; then
  pass "REQ-002: implement has a parallel dispatch section"
else
  fail "REQ-002: implement missing a parallel dispatch section"
fi

echo ""
echo "=== REQ-002: Pre-Execution Parallelism Plan in validate-agent SKILL.md ==="
if grep -qi "## Parallelism" "$VALIDATE"; then
  pass "REQ-002: validate-and-accept has a parallelism section"
else
  fail "REQ-002: validate-and-accept missing a parallelism section"
fi

echo ""
echo "=== Summary ==="
echo "  PASS: $PASS"
echo "  FAIL: $FAIL"
echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "$FAIL test(s) failed."
  exit 1
fi
