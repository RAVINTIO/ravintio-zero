#!/usr/bin/env bash
# Tests for feature 0000042-autonomous-mode-and-prefixes, req-004: phase
# numbers P0 to P4.
#
# The five phases are P0 Discovery, P1 Plan, P2 Implement, P3 Validate and
# Accept, and P4 Ship. Build-log headings use "### P<n>: {Phase Name}" with n
# from 0 to 4. Hook messages say "P0 Discovery", not "Phase 0".

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$(orch_combined "$ZERO_DIR/skills/ravintio-orchestrator")"
BUILD_LOG="$ZERO_DIR/templates/build-log.template.md"
BACKLOG="$ZERO_DIR/templates/backlog-entry.template.md"
CHECK_DESIGN="$ZERO_DIR/hooks/enforcement/check-design.mjs"
GATE_WRITE="$ZERO_DIR/hooks/enforcement/gate-write.mjs"

has() { grep -qF -- "$1" "$2" && echo yes || echo no; }
has_re() { grep -qE -- "$1" "$2" && echo yes || echo no; }
lacks() { case "$2" in *"$1"*) echo no ;; *) echo yes ;; esac; }

echo ""
echo "=== req-004 (a): build-log template uses P0 to P4 headings ==="

assert_equals "yes" "$(has '### P0: Discovery' "$BUILD_LOG")" \
  "req-004 (a): build-log template opens with ### P0: Discovery"
assert_equals "yes" "$(has 'P1: Plan, P2: Implement, P3: Validate and Accept, P4: Ship' "$BUILD_LOG")" \
  "req-004 (a): build-log template names P1 to P4 in the copy block"
assert_equals "yes" "$(has 'with n from 1 to 4' "$BUILD_LOG")" \
  "req-004 (a): build-log copy block numbers later phases 1 to 4"
assert_equals "no" "$(has_re '\bP5\b' "$BUILD_LOG")" \
  "req-004 (a): build-log template cites no P5"

echo ""
echo "=== req-004 (a): orchestrator Hard Limit 10 ==="

assert_rule orc-hard-limit-phases '`### P<n>: {Phase Name}` with n from 0 to 4' "P0 to P4"
assert_equals "yes" "$(lacks "hook parses" "$(rule_text orc-hard-limit-phases)")" \
  "req-004 (a): Hard Limit 10 makes no claim that a hook parses the heading"

echo ""
echo "=== req-004 (a): orchestrator phase table and pipeline line ==="

PHASES="$(orch_section "## Phases and Response Prefixes")"
assert_contains '| P0 | Discovery |' "$PHASES" "req-004 (a): table row P0 Discovery"
assert_contains '| P1 | Plan |' "$PHASES" "req-004 (a): table row P1 Plan"
assert_contains '| P2 | Implement |' "$PHASES" "req-004 (a): table row P2 Implement"
assert_contains '| P3 | Validate and Accept |' "$PHASES" "req-004 (a): table row P3 Validate and Accept"
assert_contains '| P4 | Ship |' "$PHASES" "req-004 (a): table row P4 Ship"
assert_rule orc-pipeline-line 'P0 Discovery -> P1 Plan -> P2 Implement -> P3 Validate and Accept -> P4 Ship'
assert_equals "yes" "$(has '## P0: Discovery' "$ORCH")" \
  "req-004 (a): orchestrator discovery heading is P0"
assert_equals "no" "$(has_re '\bP5\b' "$ORCH")" \
  "req-004 (a): orchestrator cites no P5"

echo ""
echo "=== req-004 (b): hook messages say P0 Discovery ==="

for hook in "$CHECK_DESIGN" "$GATE_WRITE"; do
  name="$(basename "$hook")"
  assert_equals "yes" "$(has 'P0 Discovery' "$hook")" \
    "req-004 (b): $name says P0 Discovery"
  assert_equals "no" "$(has 'Phase 0' "$hook")" \
    "req-004 (b): $name no longer says Phase 0"
done

TMP_WS="$(mktemp -d)"
trap 'rm -rf "$TMP_WS"' EXIT
OUT="$(printf '{"cwd":"%s"}' "$TMP_WS" | node "$CHECK_DESIGN" 2>/dev/null)"
assert_contains "P0 Discovery" "$OUT" \
  "req-004 (b): check-design.mjs emits P0 Discovery with no brief"

echo ""
echo "=== req-004 (b): backlog-entry Source phase placeholder ==="

SOURCE_LINE="$(grep -F '**Source phase:**' "$BACKLOG")"
assert_contains "P0" "$SOURCE_LINE" "req-004 (b): Source phase offers P0"
assert_contains "P4" "$SOURCE_LINE" "req-004 (b): Source phase offers P4"
assert_equals "yes" "$(lacks "P5" "$SOURCE_LINE")" "req-004 (b): Source phase no longer offers P5"

print_summary
