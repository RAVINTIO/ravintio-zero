#!/usr/bin/env bash
# 0000173 req-003: metric-markers
# Phase skills write one fixed marker line per rework loop, requirement
# change, and gate correction. The governance standard lists every marker.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"
VAL="$ZERO_DIR/skills/ravintio-validate-and-accept/SKILL.md"
ORCH="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
MID="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-mid-pipeline-changes.md"
STD="$ZERO_DIR/standards/workflow-governance-standards.md"
STD_NAME='workflow-governance-standards.md'

echo ""
echo "=== 0000173 req-003 metric-markers ==="

check() {
  if [ "$2" = "0" ]; then _pass_line "$1"; PASS=$((PASS+1)); else _fail_line "$1"; FAIL=$((FAIL+1)); fi
}
holds() { grep -qF -- "$1" "$2"; }

# AC-1: implement and validate write Rework and name the standard
assert_rule orc-impl-rework 'Rework: REQ-{nnn}:' "$STD_NAME"
assert_rule orc-p3-self-correct 'Rework: REQ-{nnn}:' "$STD_NAME"

# AC-2: reference holds Requirement change, orchestrator holds Gate revised
assert_rule orc-mid-requirement-change 'Requirement change: {cosmetic | additive | contradictory}:' "$STD_NAME"
assert_rule orc-gate-revised 'Gate revised: P{N}'

# AC-3: the standard lists every marker
assert_rule orc-gov-markers 'Rework:'
assert_rule oa-gov-marker-blocked 'Blocked:'
assert_rule oa-gov-marker-req-change 'Requirement change:'
assert_rule oa-gov-marker-gate-revised 'Gate revised:'

print_summary
