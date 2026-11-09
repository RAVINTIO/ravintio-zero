#!/usr/bin/env bash
# Tests for feature 0000391 REQ-008: archetype standard and skill text.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
STD="$ZERO_DIR/standards/archetype-standards.md"
SK="$ZERO_DIR/skills"
POINTER='ravintio-zero/standards/archetype-standards.md'

echo ""
echo "=== archetype standard ==="
if [ -f "$STD" ]; then assert_contains ok ok "standard exists"; else assert_contains ok missing "standard exists"; fi
TEXT="$(cat "$STD" 2>/dev/null)"
assert_contains 'title:' "$TEXT" "frontmatter title"
assert_contains 'status:' "$TEXT" "frontmatter status"
assert_contains 'resolve-override.mjs' "$TEXT" "names the resolver"
assert_contains 'protected.json' "$TEXT" "names protected.json"
assert_contains '`alternative`' "$TEXT" "names alternative kind"
assert_contains '`constraint`' "$TEXT" "names constraint kind"
assert_contains 'archetype use' "$TEXT" "names archetype use"
assert_contains 'archetype-gates.mjs' "$TEXT" "names the gate script"
assert_contains 'never loosens a gate' "$TEXT" "states the no-loosen rule"
LINES=$(wc -l < "$STD" 2>/dev/null | tr -d ' ')
if [ "${LINES:-999}" -lt 70 ]; then assert_contains ok ok "standard $LINES lines"; else assert_contains ok "$LINES" "standard under 70 lines"; fi

echo ""
echo "=== skills ==="
VA="$SK/ravintio-validate-and-accept/SKILL.md"
N=$(grep -c 'archetype-gates.mjs' "$VA")
if [ "$N" -eq 1 ]; then assert_contains ok ok "validate names the gate script once"; else assert_contains ok "$N" "validate names the gate script once"; fi
VL=$(wc -l < "$VA" | tr -d ' ')
if [ "$VL" -le 200 ]; then assert_contains ok ok "validate $VL <= 200"; else assert_contains ok "$VL" "validate <= 200"; fi
TOTAL=$(cat "$SK"/*/SKILL.md | wc -l | tr -d ' ')
if [ "$TOTAL" -le 1720 ]; then assert_contains ok ok "total $TOTAL <= 1720"; else assert_contains ok "$TOTAL" "total <= 1720"; fi

OB=$(wc -c < "$SK/ravintio-orchestrator/SKILL.md" | tr -d ' ')
if [ "$OB" -le 9000 ]; then assert_contains ok ok "orchestrator $OB <= 9000 bytes"; else assert_contains ok "$OB" "orchestrator <= 9000 bytes"; fi
assert_contains ok "$(grep -c 'archetype' "$SK/ravintio-orchestrator/SKILL.md" | grep -q '^0$' && echo ok)" "orchestrator holds no archetype text"

for s in ravintio-implement ravintio-plan; do
  F="$SK/$s/SKILL.md"
  assert_contains "$POINTER" "$(cat "$F")" "$s points at the standard"
  assert_contains 'resolve-override.mjs' "$(cat "$F")" "$s names the resolver"
  PL=$(grep -c "archetype-standards.md" "$F")
  if [ "$PL" -le 1 ]; then assert_contains ok ok "$s names the standard $PL time"; else assert_contains ok "$PL" "$s names the standard once"; fi
done

assert_summary 2>/dev/null || true
