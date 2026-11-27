#!/usr/bin/env bash
# Tests for feature 0000018 req-007: discovery.md elevated to Hard Limit status
# in ravintio-orchestrator/SKILL.md (self-audit finding, ADR-003).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ORCHESTRATOR="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
grep_has() { grep -q "$1" "$2" 2>/dev/null && echo "yes" || echo "no"; }

# ── AC-1: new Hard Limit entry, matching build-log.md's pattern ─────────────

echo ""
echo "=== req-007: discovery.md Hard Limit entry ==="

HL="$(orch_section "## Hard Limits")"
assert_contains "12." "$HL" \
  "req-007: Hard Limits list has the discovery.md entry"
assert_rule orc-hard-limit-discovery-md "discovery.md" "pipeline error" "stop and write it"

# ── AC-2: step 3d cross-references the new Hard Limit ────────────────────────

echo ""
echo "=== req-007: step 3d cross-reference ==="

assert_rule p0-start-discovery-md "Hard Limit 12"

# ── AC-3: Gate Checklist has a discovery.md item ─────────────────────────────

echo ""
echo "=== req-007: Gate Checklist item ==="

GATE="$(orch_section "### Discovery Gate Checklist")"
assert_contains "discovery.md" "$GATE" \
  "req-007: Gate Checklist has a discovery.md item"
assert_contains "Hard Limit 12" "$GATE" \
  "req-007: Gate Checklist item cross-references Hard Limit 12"

print_summary
