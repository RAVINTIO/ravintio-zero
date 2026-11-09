#!/usr/bin/env bash
# Test: 0000386 req-001 inline-tdd-path
# A content unit that applies agreed text or changes one file runs the TDD loop inline,
# with RED logged before GREEN. build-log-check.mjs checks the markers.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHECK="$ZERO_DIR/scripts/build-log-check.mjs"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "=== AC-1: the skill names the rule ==="
assert_rule implement-inline-unit "inline" "agreed text" "one file" "content" "RED:" "GREEN:" "no subagent" "improvement loop"
assert_rule implement-non-inline-subagents "not inline" "test-writer" "implementer" "refactor"

echo "=== Governance standard lists the markers ==="
GOV="$(cat "$ZERO_DIR/standards/workflow-governance-standards.md")"
assert_contains '`RED: {unit}' "$GOV" "standard lists the RED marker"
assert_contains '`GREEN: {unit}' "$GOV" "standard lists the GREEN marker"

# A fully valid log. Extra lines go into the P2 block through $1.
block() {
  printf '### P%s: %s\n\n| Field | Value |\n|-------|-------|\n| Start | `%s` |\n| End | `%s` |\n| Wall clock | `%s` |\n| Model tier | primary |\n\n' "$1" "$2" "$3" "$4" "$5"
  [ -n "${6:-}" ] && printf '%s\n\n' "$6"
  printf 'Complete: P%s (%s)\n\n' "$1" "$4"
}
log() {
  local d=2026-10-28
  {
    printf '# Build Log\n\n## Phase Log\n\n'
    block 0 Discovery "${d}T12:00:00Z" "${d}T12:03:00Z" 3
    block 1 Plan "${d}T12:03:00Z" "${d}T12:10:00Z" 7
    block 2 Implement "${d}T12:10:00Z" "${d}T12:30:00Z" 20 "$1"
    block 3 "Validate and Accept" "${d}T12:30:00Z" "${d}T12:40:00Z" 10
    block 4 Ship "${d}T12:40:00Z" "${d}T12:45:00Z" 5
    printf '## Summary\n\n| Metric | Value |\n|--------|-------|\n| Total phases completed | `5` |\n| Total wall clock | `45` |\n'
  } > "$TMP/log.md"
}
run_check() { log "$1"; OUT=$(node "$CHECK" "$TMP/log.md" 2>&1); CODE=$?; }

T1=2026-10-28T12:15:00Z
T2=2026-10-28T12:16:00Z
T3=2026-10-28T12:17:00Z

echo "=== AC-2: a valid inline unit passes ==="
run_check "$(printf -- '- RED: U1 (%s)\n- GREEN: U1 (%s)\n- Done: U1 (content, inline, none, %s)' "$T1" "$T2" "$T3")"
assert_equals "0" "$CODE" "AC-2: a valid inline unit adds no finding"
assert_not_contains "U1" "$OUT" "AC-2: no finding names U1"

echo "=== AC-3: GREEN with no earlier RED fails ==="
run_check "$(printf -- '- GREEN: U1 (%s)\n- RED: U1 (%s)' "$T1" "$T2")"
assert_equals "1" "$CODE" "AC-3: GREEN before RED exits 1"
assert_contains "U1" "$OUT" "AC-3: the finding names the unit"
run_check "$(printf -- '- GREEN: U7 (%s)' "$T1")"
assert_equals "1" "$CODE" "AC-3: GREEN with no RED exits 1"
assert_contains "U7" "$OUT" "AC-3: the finding names U7"

echo "=== A Done line with tier inline needs both markers ==="
run_check "$(printf -- '- GREEN: U2 (%s)\n- Done: U2 (content, inline, none, %s)' "$T1" "$T2")"
assert_equals "1" "$CODE" "inline Done with no RED fails"
assert_contains "U2" "$OUT" "the finding names U2"
run_check "$(printf -- '- RED: U3 (%s)\n- Done: U3 (content, inline, none, %s)' "$T1" "$T2")"
assert_equals "1" "$CODE" "inline Done with no GREEN fails"
assert_contains "U3" "$OUT" "the finding names U3"
run_check "$(printf -- '- Done: U4 (content, haiku, low, %s)' "$T1")"
assert_equals "0" "$CODE" "a non-inline Done needs no markers"

print_summary
