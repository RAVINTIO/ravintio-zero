# Changelog (0000566-test-impact-for-history-moves, 15 Nov 2026)

**Feature:** Test impact scan misses suites that scan live files
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The plan skill's Test impact scan has a `History move` cause. It fires when a run moves or copies archived content into a live folder. It names a grep of `ravintio-zero/tests/` for `plan/_archive/`, which finds the suites that skip the archive as history. The plan lists each match under `## Test impact`. A new suite checks the cause in both pack trees.

## Why

Step 8 of feature 0000384 moved 270 ADRs from `plan/_archive/` to `docs/adr/`. Eleven suites flagged the moved text, and the scan named none of them. A fix pass followed.

## Deviations

None.

## Validation results

The full suite in a clean clone passes apart from three inherited failures. This step folds in backlog entry 0000405.

## Skipped phases

None
