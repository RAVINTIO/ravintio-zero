#!/usr/bin/env bash
# Tests for feature 0000377-driver-stops-and-headroom, req-001: Context Hygiene moves from the
# orchestrator SKILL.md to a reference file and leaves headroom under the size cap.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SKILL="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
REF="$ZERO_DIR/skills/ravintio-orchestrator/references/orchestrator-context-hygiene.md"

echo ""
# Cap raised from 8700 to 9000 for the light track row and the commit grouping pointer (0000387).
echo "=== req-001 AC-1: the skill is 9000 bytes or fewer ==="
BYTES=$(wc -c < "$SKILL" | tr -d ' ')
assert_equals "yes" "$([ "$BYTES" -le 9000 ] && echo yes || echo no)" "req-001 AC-1: SKILL.md holds $BYTES bytes (cap 9000)"

echo ""
echo "=== req-001 AC-2: the reference holds the text ==="
assert_equals "yes" "$([ -f "$REF" ] && echo yes || echo no)" "req-001 AC-2: the reference file exists"
R=$(cat "$REF" 2>/dev/null)
assert_contains "Clear context at two bookends" "$R" "req-001 AC-2: the bookends rule is in the reference"
assert_contains "Advisory only: never block on it." "$R" "req-001 AC-2: the advisory line is in the reference"
S=$(cat "$SKILL")
assert_equals "0" "$(printf '%s\n' "$S" | grep -c '^## Context Hygiene')" "req-001 AC-2: SKILL.md has no Context Hygiene heading"

echo ""
echo "=== req-001 AC-3: the Pack Index points to it ==="
assert_contains "references/orchestrator-context-hygiene.md" "$S" "req-001 AC-3: a Pack Index row names the reference"

print_summary
