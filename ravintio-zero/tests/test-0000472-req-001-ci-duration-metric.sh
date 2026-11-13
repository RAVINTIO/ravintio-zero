#!/usr/bin/env bash
# Feature 0000472 req-001: workflow-metrics.mjs reports the longest CI duration marker.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$ZERO_DIR/scripts/workflow-metrics.mjs"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

# run_metrics <folder>: sets OUT (stdout) and CODE.
run_metrics() {
  OUT=$(node "$SCRIPT" "$1" 2>"$TMP_ROOT/err")
  CODE=$?
}

echo "=== AC-1: reports the longest run ==="
F="$TMP_ROOT/two"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
# Build log

CI duration: 280s (run 100, 2026-11-10T10:00:00Z)
- CI duration: 310s (run 101, 2026-11-10T11:00:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-1: exits 0"
assert_contains '| Longest CI run (seconds) | 310 (run 101) | 420 | ok |' "$OUT" "AC-1: row shows the longest run"

echo "=== AC-2: a breach does not block ==="
F="$TMP_ROOT/slow"; mkdir -p "$F"
cat > "$F/build-log.md" <<'LOG'
CI duration: 500s (run 102, 2026-11-10T12:00:00Z)
LOG
run_metrics "$F"
assert_equals "0" "$CODE" "AC-2: exits 0 on a breach"
assert_contains '| Longest CI run (seconds) | 500 (run 102) | 420 | breach |' "$OUT" "AC-2: row reads breach"
assert_contains "Breaches: 1." "$OUT" "AC-2: breach count includes the CI row"

echo "=== AC-3: no marker ==="
F="$TMP_ROOT/none"; mkdir -p "$F"
printf '# Build log\n\nCI duration is long in prose.\n' > "$F/build-log.md"
run_metrics "$F"
assert_equals "0" "$CODE" "AC-3: exits 0"
assert_contains '| Longest CI run (seconds) | 0 | 420 | ok |' "$OUT" "AC-3: row shows 0 and ok"

print_summary
