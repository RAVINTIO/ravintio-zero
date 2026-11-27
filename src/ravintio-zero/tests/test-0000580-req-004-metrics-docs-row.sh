#!/usr/bin/env bash
# Test: 0000580 req-004 metrics-docs-row
# workflow-metrics.mjs counts docs units in a row named docs.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$ZERO_DIR/scripts/workflow-metrics.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT
run_metrics() { OUT=$(node "$SCRIPT" "$1" 2>"$TMP_ROOT/err"); CODE=$?; }

echo "=== AC-1: a docs unit has its own row ==="
F="$TMP_ROOT/ac1"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log
- Done: U-005 docs (docs, inline, none, 2026-11-26T10:00:00Z)
- Done: REQ-001 writer (content, inline, none, 2026-11-26T10:10:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-1: exits 0"
assert_contains "| docs | inline | 1 | 0 |" "$OUT" "AC-1: the docs row holds one unit"
assert_contains "| content | inline | 1 | 0 |" "$OUT" "AC-1: the content row stays apart"

echo "=== AC-2: an older Done line stays unclassified ==="
F="$TMP_ROOT/ac2"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log
- Done: REQ-001 old (2026-11-26T10:00:00Z)
LOG
run_metrics "$F"
assert_contains "| unclassified | unclassified | 1 | 0 |" "$OUT" "AC-2: the unclassified row holds the old line"
assert_not_contains "| docs |" "$OUT" "AC-2: no docs row appears"

print_summary
