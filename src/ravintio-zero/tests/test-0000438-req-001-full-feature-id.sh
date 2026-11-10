#!/usr/bin/env bash
# Tests for feature 0000438 REQ-001: initiative-add-step.mjs writes the full feature id.
# AC-1: the new Steps row holds {id}-{slug}. AC-2: the driver pattern accepts it.
# AC-3: the driver pattern and FEATURE_ID in initiative-chart.mjs are the same.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SCRIPTS="$SCRIPT_DIR/../scripts"
ADD="${ADD_STEP:-$SCRIPTS/initiative-add-step.mjs}"
TEMPLATE="$SCRIPT_DIR/../templates/initiative.template.md"

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

WS="$TMP_ROOT/ws"
mkdir -p "$WS/plan/backlog" "$WS/plan/current-initiative"
printf '0000500\n' > "$WS/plan/backlog/.next-id"
CHART="$WS/plan/current-initiative/initiative.md"
sed 's/{{1 to 9, default 3}}/3/' "$TEMPLATE" > "$CHART"

echo ""
echo "=== AC-1: full id in the row ==="
(cd "$WS" && node "$ADD" --title "Add a sample step" --slug sample-step >/dev/null 2>&1)
assert_equals "0" "$?" "add-step exits 0"

CELL="$(node --input-type=module -e "
import fs from 'node:fs';
import { parseChart } from '$SCRIPTS/initiative-chart.mjs';
const c = parseChart(fs.readFileSync('$CHART', 'utf8'));
console.log(c.steps[c.steps.length - 1].featureId);
" 2>&1)"
assert_equals "0000500-sample-step" "$CELL" "Feature id cell holds the id and the slug"

echo ""
echo "=== AC-2: the driver pattern accepts the row ==="
DRIVER_PATTERN="$(sed -n 's/^const FEATURE = \(\/.*\/\);$/\1/p' "$SCRIPTS/initiative-run.mjs")"
if [ -z "$DRIVER_PATTERN" ]; then
  assert_equals "found" "missing" "initiative-run.mjs defines const FEATURE"
fi
MATCH="$(node -e "console.log(($DRIVER_PATTERN).test(process.argv[1]))" "$CELL" 2>&1)"
assert_equals "true" "$MATCH" "the driver FEATURE pattern matches the Feature id cell"

echo ""
echo "=== AC-3: one pattern ==="
SHARED="$(node --input-type=module -e "
import { FEATURE_ID } from '$SCRIPTS/initiative-chart.mjs';
console.log(String(FEATURE_ID));
" 2>&1)"
assert_equals "$DRIVER_PATTERN" "$SHARED" "FEATURE_ID in initiative-chart.mjs equals const FEATURE in initiative-run.mjs"

print_summary
