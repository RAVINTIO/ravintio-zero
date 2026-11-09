#!/usr/bin/env bash
# Tests for feature 0000379, req-004 AC-2: updateChart rewrites the chart Position field.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

TOOL="$SCRIPT_DIR/../scripts/merge-queue.mjs"

# run_update POSITION_LINE S1 S2 S3 STEP: prints the updated chart. Empty POSITION_LINE omits the field.
run_update() {
  POS_LINE="$1" S1="$2" S2="$3" S3="$4" STEP="$5" TOOL="$TOOL" node --input-type=module -e '
    const { updateChart } = await import(process.env.TOOL);
    const e = process.env;
    const row = (n, s) => `| ${n} | 0000379-x | Title ${n} | | minor | | ${s} |`;
    const lines = ["# Chart", "", "**Status:** active"];
    if (e.POS_LINE) lines.push(e.POS_LINE);
    lines.push("", "## Steps", "", "| Step | Feature id | Title | Backlog entries | Bump | Version | Status |",
      "|------|------------|-------|-----------------|------|---------|--------|",
      row(1, e.S1), row(2, e.S2), row(3, e.S3), "", "Closing text.", "");
    const once = updateChart(lines.join("\n"), { step: Number(e.STEP), pr: "7", version: "1.2.3", mergedAt: "2026-11-07" });
    const twice = updateChart(once, { step: Number(e.STEP), pr: "7", version: "1.2.3", mergedAt: "2026-11-07" });
    process.stdout.write(once + (once === twice ? "" : "\nNOT-IDEMPOTENT"));
  '
}

OUT="$(run_update '**Position:** 3' pending merged pending 2)"
assert_contains "**Position:** 1" "$OUT" "REQ-004: step 2 merged while step 1 pending sets Position 1"
assert_not_contains "NOT-IDEMPOTENT" "$OUT" "REQ-004: applying the update twice gives the same text"

OUT="$(run_update '**Position:** 3' merged pending ready 2)"
assert_contains "**Position:** 3" "$OUT" "REQ-004: step 3 ready stays the lowest unmerged"

OUT="$(run_update '**Position:** 3' merged merged running 2)"
assert_contains "**Position:** 3" "$OUT" "REQ-004: running counts as not merged"

OUT="$(run_update '**Position:** 1' merged pending merged 3)"
assert_contains "**Position:** 2" "$OUT" "REQ-004: Position moves up to the first unmerged step"

OUT="$(run_update '**Position:** 1' merged merged merged 3)"
assert_contains "**Position:** 4" "$OUT" "REQ-004: all merged sets one past the last step"

OUT="$(run_update 'position: 3' pending merged pending 2)"
assert_contains "position: 1" "$OUT" "REQ-004: lower-case field keeps its style"

OUT="$(run_update '' pending merged pending 2)"
assert_not_contains "osition" "$OUT" "REQ-004: absent field is not added"

print_summary
