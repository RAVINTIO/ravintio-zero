#!/usr/bin/env bash
# Test: 0000487 req-001 decision-rows.mjs
# The module lists the Decisions rows that name a step, with ranges expanded.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

MOD="$SCRIPT_DIR/../scripts/decision-rows.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/chart.md" <<'CHART'
# Initiative

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1-21 | Confirmation: setup rerun | Run the setup command | none |
| 25-41 | Local suite runs | Run 4 shards | none |
| 1, 3 | Two steps | Do both | none |
| 3 | Colon: in the fork | Keep the colon | none |
| 45 | none | none | none |
| 46 | none | none | none |

## Baselines

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 40 | Not a decision row | skip | none |
CHART

echo ""
echo "=== req-001 AC-1: a range row names every step in it ==="
OUT=$(node "$MOD" list --step 40 --chart "$TMP/chart.md" 2>&1)
assert_contains "Local suite runs => Run 4 shards" "$OUT" "req-001 AC-1: step 40 gets the 25-41 row"
assert_not_contains "Not a decision row" "$OUT" "req-001 AC-1: only the Decisions table is read"
OUT=$(node "$MOD" list --step 41 --chart "$TMP/chart.md" 2>&1)
assert_contains "Local suite runs" "$OUT" "req-001 AC-1: the end of the range matches"
OUT=$(node "$MOD" list --step 42 --chart "$TMP/chart.md" 2>&1)
assert_equals "none" "$OUT" "req-001 AC-1: a step past the range gets none"

echo ""
echo "=== req-001 AC-2: a step with only a none row gets none ==="
OUT=$(node "$MOD" list --step 45 --chart "$TMP/chart.md" 2>&1); CODE=$?
assert_equals "none" "$OUT" "req-001 AC-2: step 45 gets none"
assert_equals "0" "$CODE" "req-001 AC-2: exit 0"

echo ""
echo "=== req-001 AC-3: a comma list and a single number both match ==="
OUT=$(node "$MOD" list --step 3 --chart "$TMP/chart.md" 2>&1)
assert_contains "Two steps => Do both" "$OUT" "req-001 AC-3: the comma list matches"
assert_contains "Colon: in the fork => Keep the colon" "$OUT" "req-001 AC-3: the single row matches, colon kept"
assert_contains "Confirmation: setup rerun" "$OUT" "req-001 AC-3: the 1-21 range matches step 3"

echo ""
echo "=== req-001: a missing chart gives none ==="
OUT=$(node "$MOD" list --step 3 --chart "$TMP/absent.md" 2>&1); CODE=$?
assert_equals "none" "$OUT" "req-001: a missing chart gives none"
assert_equals "0" "$CODE" "req-001: a missing chart exits 0"

print_summary
