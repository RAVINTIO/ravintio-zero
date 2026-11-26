#!/usr/bin/env bash
# Tests for feature 0000023-pipeline-fixes, req-002:
# marker commit lifecycle.
#
# Covers: session markers (plan/.orchestrator-active, plan/.orchestrator-ack,
# plan/.run-mode) must be committed at the point they are written (discovery),
# and the ship phase must clear them, stage the deletions, and confirm with
# git ls-files that none remain tracked. Since 0000042 req-001,
# plan/.run-mode holds `gated` or `autonomous`.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ORCHESTRATOR="$(orch_combined "$SCRIPT_DIR/../skills/ravintio-orchestrator")"
SHIP="$SCRIPT_DIR/../skills/ravintio-ship/SKILL.md"

for f in "$ORCHESTRATOR" "$SHIP"; do
  if [ ! -f "$f" ]; then
    echo "  FAIL: $f not found"
    ((FAIL++)) || true
    print_summary
  fi
done

echo ""
echo "=== req-002: creation-side commit instructions (orchestrator discovery) ==="

assert_rule p0-start-sentinel "Write the sentinel" "Include in the discovery commit."
assert_rule p0-start-strict-ack "Strict-mode ack" "include it in the discovery commit"
assert_rule orc-run-mode-write 'write `plan/.run-mode`' "Include it in the discovery commit." '`gated` or `autonomous`'

echo ""
echo "=== req-002: deletion-side clearing (ship phase) ==="

assert_rule orc-ship-clear-markers 'Delete `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode`' \
  "Stage the deletions and commit." 'git ls-files'

echo ""
echo "=== req-002: interrupted-ship recovery ==="

assert_rule resume-interrupted-ship "Interrupted-ship cleanup"

print_summary
