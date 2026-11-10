#!/usr/bin/env bash
# Tests for feature 0000399 REQ-002: initiative-add-step.mjs.
# AC-1: ids reserved, entry filed, index rebuilt. AC-2: every chart table gains a row.
# AC-3: the chart still parses.

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

# Build a two-step chart from the template: copy each step 1 row as step 2.
node -e '
const fs = require("node:fs");
const [tpl, out] = process.argv.slice(1);
const res = [];
let inMerges = false;
for (const l of fs.readFileSync(tpl, "utf8").split("\n")) {
  if (l.startsWith("## Merges")) inMerges = true;
  res.push(l);
  if (!inMerges && /^\| 1 \|/.test(l)) res.push(l.replace(/^\| 1 \|/, "| 2 |"));
}
fs.writeFileSync(out, res.join("\n").replace("{{1 to 9, default 3}}", "3"));
' "$TEMPLATE" "$CHART"

echo ""
echo "=== add-step ==="
OUT="$(cd "$WS" && node "$ADD" --title "Add a sample step" --slug sample-step --bump minor --lane core --after 2 2>&1)"
RC=$?
assert_equals "0" "$RC" "add-step exits 0"

for t in "Schema changes" "Dependencies" "Decisions" "Baselines" "Criteria" "P1 skips" "Steps"; do
  COUNT="$(awk -v t="## $t" '$0==t{f=1;next} /^## /{f=0} f && /^\| 3 \|/{n++} END{print n+0}' "$CHART")"
  assert_equals "1" "$COUNT" "$t holds one row for step 3"
  KEPT="$(awk -v t="## $t" '$0==t{f=1;next} /^## /{f=0} f && /^\| [12] \|/{n++} END{print n+0}' "$CHART")"
  EXPECT=2
  [ "$t" = "Decisions" ] && EXPECT=4
  assert_equals "$EXPECT" "$KEPT" "$t keeps the existing rows"
done

PARSED="$(node --input-type=module -e "
import fs from 'node:fs';
import { parseChart } from '$SCRIPTS/initiative-chart.mjs';
const c = parseChart(fs.readFileSync('$CHART', 'utf8'));
const s = c.steps[c.steps.length - 1];
console.log([c.steps.length, s.step, s.title, s.bump, s.status, s.lane, s.after.join(',')].join('|'));
" 2>&1)"
assert_equals "3|3|Add a sample step|minor|pending|core|2" "$PARSED" "chart parses with the new step last"

# The Steps row names the reserved feature id and backlog id.
ROW="$(grep '^| 3 |' "$CHART" | tail -1)"
assert_contains "| 0000500 |" "$ROW" "Steps row holds the feature id"
assert_contains "| 0000501 |" "$ROW" "Steps row holds the backlog id"
assert_equals "0000502" "$(tr -d '\n' < "$WS/plan/backlog/.next-id")" "counter advanced by two"

ENTRY="$WS/plan/backlog/0000501-sample-step/entry.md"
if [ -f "$ENTRY" ]; then assert_equals "y" "y" "backlog entry exists"; else assert_equals "y" "n" "backlog entry exists"; fi
assert_contains "Add a sample step" "$(cat "$ENTRY" 2>/dev/null)" "entry holds the title"

INDEX="$(cat "$WS/plan/backlog/index.md" 2>/dev/null)"
assert_contains "0000501" "$INDEX" "backlog index lists the new entry"
(cd "$WS" && node "$SCRIPTS/backlog-index.mjs" --check >/dev/null 2>&1)
assert_exit_zero "$?" "backlog index is current"

echo ""
echo "=== bad input ==="
(cd "$WS" && node "$ADD" --slug x >/dev/null 2>&1)
assert_equals "1" "$?" "missing title exits 1"
assert_equals "0000502" "$(tr -d '\n' < "$WS/plan/backlog/.next-id")" "failed run reserves nothing"

print_summary
