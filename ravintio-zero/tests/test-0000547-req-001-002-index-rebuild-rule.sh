#!/usr/bin/env bash
# Tests for feature 0000547 REQ-001 and REQ-002: I-D Advance tells a step to rebuild the backlog index after a manual base merge.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="${ZERO_DIR:-$SCRIPT_DIR/..}"
STD="$ZERO_DIR/standards/roadmap-standards.md"

# The I-D Advance section, up to the next level-three heading.
ADV="$(awk '/^### I-D Advance/ {on=1; next} on && /^### / {exit} on {print}' "$STD")"

echo "=== req-001: the rebuild rule sits in I-D Advance ==="
assert_contains "rule: advance-index-rebuild" "$ADV" "AC-1: the section holds the rule anchor"
assert_rule "advance-index-rebuild" \
  "node ravintio-zero/scripts/backlog-index.mjs" \
  "commit the result before the push" \
  "Check the backlog index" \
  "validate-branch"

echo "=== req-002: the pack trees match ==="
if [ -f "$ZERO_DIR/../../ravintio-zero/standards/roadmap-standards.md" ] && [ -d "$ZERO_DIR/../../src" ]; then
  assert_equals "same" \
    "$(cmp -s "$ZERO_DIR/standards/roadmap-standards.md" "$ZERO_DIR/../../ravintio-zero/standards/roadmap-standards.md" && echo same || echo differ)" \
    "AC-2: the installed copy holds the same standards text"
fi

print_summary
