#!/usr/bin/env bash
# Feature 0000386 req-003: workflow-metrics.mjs reports units and rework by class and tier.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$ZERO_DIR/scripts/workflow-metrics.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

# run_metrics <folder>: sets OUT (stdout), CODE.
run_metrics() {
  OUT=$(node "$SCRIPT" "$1" 2>"$TMP_ROOT/err")
  CODE=$?
}

HEADING="## Dispatch by class and tier"

echo "=== AC-1: units are counted by class and tier ==="
F="$TMP_ROOT/ac1"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log
- Done: REQ-001 implementer (code, primary, medium, 2026-11-09T10:00:00Z)
- Done: REQ-002 implementer (code, primary, high, 2026-11-09T10:10:00Z)
- Done: REQ-003 writer (content, inline, none, 2026-11-09T10:20:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-1: exits 0"
assert_contains "$HEADING" "$OUT" "AC-1: prints the section heading"
assert_contains "| Class | Tier | Units | Rework |" "$OUT" "AC-1: header row"
assert_contains "| code | primary | 2 | 0 |" "$OUT" "AC-1: code/primary row has 2 units"
assert_contains "| content | inline | 1 | 0 |" "$OUT" "AC-1: content/inline row has 1 unit"
GOV_LINE=$(printf '%s\n' "$OUT" | grep -n '^## Workflow governance' | cut -d: -f1)
DISP_LINE=$(printf '%s\n' "$OUT" | grep -n '^## Dispatch by class and tier' | cut -d: -f1)
assert_equals "yes" "$([ -n "$GOV_LINE" ] && [ -n "$DISP_LINE" ] && [ "$DISP_LINE" -gt "$GOV_LINE" ] && echo yes || echo no)" "AC-1: section follows the governance table"
CODE_ROW=$(printf '%s\n' "$OUT" | grep -n '^| code | primary' | cut -d: -f1)
CONTENT_ROW=$(printf '%s\n' "$OUT" | grep -n '^| content | inline' | cut -d: -f1)
assert_equals "yes" "$([ -n "$CODE_ROW" ] && [ -n "$CONTENT_ROW" ] && [ "$CODE_ROW" -lt "$CONTENT_ROW" ] && echo yes || echo no)" "AC-1: rows sort by class"

echo "=== AC-2: rework follows the unit ==="
F="$TMP_ROOT/ac2"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log
- Done: REQ-001 implementer (code, primary, medium, 2026-11-09T10:00:00Z)
- Rework: REQ-001: assertion failed (2026-11-09T10:05:00Z)
- Rework: REQ-009: no earlier Done line (2026-11-09T10:06:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-2: exits 0"
assert_contains "| code | primary | 1 | 1 |" "$OUT" "AC-2: code/primary row shows one rework"
assert_contains "| unclassified | unclassified | 0 | 1 |" "$OUT" "AC-2: orphan rework counts as unclassified"

echo "=== AC-3: legacy Done lines count as unclassified ==="
F="$TMP_ROOT/ac3"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log
- Done: REQ-001 implementer (2026-11-09T10:00:00Z)
- Done: REQ-002 implementer (2026-11-09T10:10:00Z)
Blocked: x (2026-11-09T10:20:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-3: exits 0"
assert_contains "| unclassified | unclassified | 2 | 0 |" "$OUT" "AC-3: two unclassified units"
assert_contains '| `Blocked:` stops | 1 | 1 | ok |' "$OUT" "AC-3: governance row unchanged"
assert_contains "Breaches: 0. The gate reports and does not block. Counts come from marker lines only." "$OUT" "AC-3: Breaches line unchanged"

echo "=== No dispatched units ==="
F="$TMP_ROOT/empty"; mkdir -p "$F"
printf '# Build log\nNothing.\n' > "$F/build-log.md"
run_metrics "$F"
assert_equals "0" "$CODE" "empty: exits 0"
assert_contains "No dispatched units." "$OUT" "empty: prints the empty message"

echo "=== Existing 0000173 tests still pass ==="
for t in test-0000173-req-001-workflow-metrics-script.sh test-0000173-req-002-thresholds-gate.sh test-0000173-req-003-metric-markers.sh; do
  bash "$SCRIPT_DIR/$t" >/dev/null 2>&1
  assert_equals "0" "$?" "$t passes"
done

print_summary
