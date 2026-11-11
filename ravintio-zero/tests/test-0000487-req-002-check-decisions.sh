#!/usr/bin/env bash
# Test: 0000487 req-002 build-log-check check 9
# A step build log needs a line for each Decisions row that names its step.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

CHECK="$SCRIPT_DIR/../scripts/build-log-check.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

block() {
  printf '### P%s: %s\n\n| Field | Value |\n|-------|-------|\n| Start | `%s` |\n| End | `%s` |\n| Wall clock | `%s` |\n| Model tier | primary |\n\n' "$1" "$2" "$3" "$4" "$5"
  printf 'Complete: P%s (%s)\n\n' "$1" "$4"
}
# log <project> <extra lines>: a clean log for feature 0000040-demo, plus extra lines in P0.
log() {
  mkdir -p "$1/plan/current"
  {
    printf '# Build Log\n\n## Header\n\n| Field | Value |\n|-------|-------|\n| Feature ID | `0000040-demo` |\n\n## Phase Log\n\n'
    block 0 Discovery 2026-10-28T12:00:00Z 2026-10-28T12:03:00Z 3
    [ -n "${2:-}" ] && printf '%s\n\n' "$2"
    block 1 Plan 2026-10-28T12:03:00Z 2026-10-28T12:10:00Z 7
    block 2 Implement 2026-10-28T12:10:00Z 2026-10-28T12:30:00Z 20
    block 3 "Validate and Accept" 2026-10-28T12:30:00Z 2026-10-28T12:40:00Z 10
    block 4 Ship 2026-10-28T12:40:00Z 2026-10-28T12:45:00Z 5
    printf '## Summary\n\n| Metric | Value |\n|--------|-------|\n| Total wall clock | `45` |\n'
  } > "$1/plan/current/build-log.md"
}
chart() {
  mkdir -p "$1/plan/current-initiative"
  cat > "$1/plan/current-initiative/initiative.md" <<'CHART'
# Initiative

**Concurrency:** 3

## Decisions

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 8-12 | Local suite runs | Run 4 shards | none |
| 9 | Colon: in the fork | Keep it | none |
| 10 | none | none | none |

## Steps

| Step | Feature id | Title | Backlog entries | Bump | Version | Status | Lane | After |
|------|------------|-------|-----------------|------|---------|--------|------|-------|
| 9 | 0000040-demo | Demo | 0000041 | minor |  | pending | a | |
| 10 | 0000042-other | Other | 0000043 | minor |  | pending | b | |
CHART
}
run_check() { OUT=$(node "$CHECK" "$1/plan/current/build-log.md" 2>&1); CODE=$?; }

echo ""
echo "=== req-002 AC-1: a missed row fails ==="
P="$TMP/a"; log "$P" ""; chart "$P"; run_check "$P"
assert_equals "1" "$CODE" "req-002 AC-1: a log with no line for the rows fails"
assert_contains "Local suite runs" "$OUT" "req-002 AC-1: the finding names the fork"
assert_contains "Colon: in the fork" "$OUT" "req-002 AC-1: the finding names the second fork"

echo ""
echo "=== req-002 AC-2: a logged row passes ==="
P="$TMP/b"
log "$P" "- Decision applied (initiative chart): Local suite runs
- Decision not applicable (initiative chart): Colon: in the fork: the step has no suite"
chart "$P"; run_check "$P"
assert_equals "0" "$CODE" "req-002 AC-2: applied and not applicable lines pass"
assert_not_contains "Decisions:" "$OUT" "req-002 AC-2: no Decisions finding"

echo ""
echo "=== req-002 AC-2: one missing line still fails ==="
P="$TMP/c"; log "$P" "Decision applied (initiative chart): Local suite runs"; chart "$P"; run_check "$P"
assert_equals "1" "$CODE" "req-002 AC-2: one row without a line fails"
assert_contains "Colon: in the fork" "$OUT" "req-002 AC-2: the finding names the missing fork"
assert_not_contains 'row "Local suite runs"' "$OUT" "req-002 AC-2: the logged row is not named"

echo ""
echo "=== req-002 AC-3: no chart, or no matching row, passes ==="
P="$TMP/d"; log "$P" ""; run_check "$P"
assert_equals "0" "$CODE" "req-002 AC-3: no chart adds no finding"
P="$TMP/e"; log "$P" ""; chart "$P"
sed -i.bak 's/0000040-demo/0000099-unlisted/' "$P/plan/current/build-log.md"; run_check "$P"
assert_equals "0" "$CODE" "req-002 AC-3: a Feature ID missing from the chart adds no finding"

print_summary
