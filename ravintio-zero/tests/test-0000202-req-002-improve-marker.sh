#!/usr/bin/env bash
# Tests for feature 0000202-improvement-loops, req-002: the workflow governance
# standard lists the Improve marker and the living docs name the improvement loop.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
STD="$ZERO_DIR/standards/workflow-governance-standards.md"
MANIFEST="$ZERO_DIR/component.yml"
ARCH="$REPO_ROOT/docs/architecture-overview.md"
PIPE="$ZERO_DIR/pipeline-reference.md"


echo ""
echo "=== req-002 AC-1: the standard lists both marker forms ==="
assert_rule oa-improve-marker-change "Improve: REQ-{nnn}: cycle {n}: {finding}: {change}: suite {pass | fail, reverted}"
assert_rule oa-improve-marker-early "Improve: REQ-{nnn}: cycle {n}: no change worth making"

echo ""
echo "=== req-002 AC-2: the standard says the script ignores the marker ==="
assert_rule oa-improve-script-ignores "does not count" '`workflow-metrics.mjs` does not count'

echo ""
echo "=== req-002 AC-3: the living docs name the loop ==="
assert_contains "improvement loop" "$(cat "$MANIFEST")" "req-002 AC-3: component.yml names the improvement loop"
assert_contains "improvement loop" "$(cat "$ARCH")" "req-002 AC-3: the architecture overview names the improvement loop"
assert_contains "improvement loop" "$(cat "$PIPE")" "req-002 AC-3: the pipeline reference names the improvement loop"

print_summary
