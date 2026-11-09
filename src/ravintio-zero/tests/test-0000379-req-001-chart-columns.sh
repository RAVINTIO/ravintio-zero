#!/usr/bin/env bash
# Tests for feature 0000379-parallel-steps-on-worktrees, req-001 (chart columns and fields).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/initiative-chart.mjs"
TEMPLATE="$SCRIPT_DIR/../templates/initiative.template.md"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# AC-1: the template holds the columns and the field.
STEPS_HEADER="$(awk '/^## Steps/{f=1;next} f&&/^\|/{print;exit}' "$TEMPLATE")"
assert_contains "| Status | Lane | After |" "$STEPS_HEADER" "REQ-001 AC-1: Steps table ends with Status, Lane, After"
assert_contains '**Concurrency:** {{1 to 9, default 3}}' "$(cat "$TEMPLATE")" "REQ-001 AC-1: template holds the Concurrency field"
assert_not_contains "## Lanes" "$(cat "$TEMPLATE")" "REQ-001 AC-1: template holds no Lanes section"

# Run a node snippet against the module. $1 is a chart file, $2 is JS using `c` and `text`.
run_js() {
  node --input-type=module -e "
import { readFileSync } from 'node:fs';
import * as c from '$TOOL';
const text = readFileSync('$1', 'utf8');
$2" 2>&1
}

# AC-2: lanes and ranges.
cat > "$WORK/new.md" <<'CHART'
# Initiative: x

**Concurrency:** 4

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 1 | 0000401-a | First | | minor | | merged | core | |
| 2 | 0000402-b | Second | | minor | | pending | core | 1 |
| 3 | 0000403-c | Third | | patch | | pending | docs | none |
| 4 | 0000404-d | Fourth | | minor | | pending | ui | 6, 13 |
| 5 | 0000405-e | Fifth | | minor | | pending | all | 1-3 |

## Merges
CHART
OUT="$(run_js "$WORK/new.md" 'const r = c.parseChart(text); console.log(JSON.stringify([r.concurrency, r.hasConcurrency, r.steps.map(s => [s.step, s.lane, s.status, s.after])]))')"
assert_equals '[4,true,[[1,"core","merged",[]],[2,"core","pending",[1]],[3,"docs","pending",[]],[4,"ui","pending",[6,13]],[5,"all","pending",[1,2,3]]]]' "$OUT" "REQ-001 AC-2: lanes, After lists, and ranges parse"
OUT="$(run_js "$WORK/new.md" 'const s = c.parseChart(text).steps[1]; console.log(s.featureId, s.title, s.bump, s.version === "")')"
assert_equals "0000402-b Second minor true" "$OUT" "REQ-001 AC-2: other columns parse by name"

# AC-3: an old chart still parses.
cat > "$WORK/old.md" <<'CHART'
# Initiative: y

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status |
|------|------------|-------|-----------------|------|---------|--------|
| 1 | 0000401-a | First | | minor | | pending |
| 2 | 0000402-b | Second | | minor | | pending |
CHART
OUT="$(run_js "$WORK/old.md" 'const r = c.parseChart(text); console.log(JSON.stringify([r.concurrency, r.hasConcurrency, r.steps.map(s => [s.lane, s.after])]))')"
assert_equals '[1,false,[["step-1",[]],["step-2",[]]]]' "$OUT" "REQ-001 AC-3: old chart gives concurrency 1 and own lanes"

# Concurrency validation.
for bad in 0 10 2.5 abc; do
  sed "s/^\*\*Concurrency:\*\* 4/**Concurrency:** $bad/" "$WORK/new.md" > "$WORK/bad.md"
  OUT="$(run_js "$WORK/bad.md" 'try { c.parseChart(text); console.log("ok"); } catch (e) { console.log("throw"); }')"
  assert_equals "throw" "$OUT" "REQ-001: Concurrency $bad throws"
done
sed "s/^\*\*Concurrency:\*\* 4/**Concurrency:** 9/" "$WORK/new.md" > "$WORK/nine.md"
OUT="$(run_js "$WORK/nine.md" 'console.log(c.parseChart(text).concurrency)')"
assert_equals "9" "$OUT" "REQ-001: Concurrency 9 is accepted"

# readySteps.
RS='
const mk = (step, status, lane, after = []) => ({ step, status, lane, after });
const show = (steps, states = new Map()) => console.log(JSON.stringify(c.readySteps(steps, states).map(s => s.step)));
'
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"merged","a"), mk(2,"pending","a",[1]), mk(3,"pending","b",[2])])')"
assert_equals "[2]" "$OUT" "REQ-001: a step waits for its After steps to merge"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"pending","a"), mk(2,"pending","a"), mk(3,"pending","b")])')"
assert_equals "[1,3]" "$OUT" "REQ-001: one lane yields only its earliest pending step"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"pending","a"), mk(2,"pending","a"), mk(3,"pending","b")], new Map([[1,"running"]]))')"
assert_equals "[3]" "$OUT" "REQ-001: a running step holds its lane and is not listed"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"pending","a"), mk(2,"pending","a")], new Map([[1,"ready"]]))')"
assert_equals "[]" "$OUT" "REQ-001: a ready step holds its lane"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"pending","a"), mk(2,"pending","b",[1])])')"
assert_equals "[1]" "$OUT" "REQ-001: an After step that is pending blocks its dependant"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"merged","a"), mk(2,"pending","a",[1]), mk(3,"pending","b",[1]), mk(4,"pending","c",[1]), mk(5,"pending","d",[1]), mk(6,"pending","e",[1])])')"
assert_equals "[2,3,4,5,6]" "$OUT" "REQ-001: the ready list holds no concurrency cap"
OUT="$(run_js "$WORK/new.md" "$RS"'show([mk(1,"merged","a"), mk(2,"pending","b"), mk(3,"pending","c",[1,2])], new Map([[2,"running"]]))')"
assert_equals "[]" "$OUT" "REQ-001: a running After step blocks the all-files step"

print_summary
