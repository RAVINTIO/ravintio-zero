# Changelog (0000565-layout-move-test-impact, 15 Nov 2026)

**Feature:** Test impact scan for layout moves
**Version:** set by the merge queue at merge
**PR:** 224

## What changed

The plan skill's Test impact scan has a `Path move` cause. It fires when a run renames or moves a folder. It lists suites that find the repo root with `$ZERO_DIR/..` or `SCRIPT_DIR/../..`. It also lists each state file that keys data by path, such as `plan/state/prose-baseline.json`. A new suite checks the cause in both pack trees.

## Why

Feature 0000397 moved the pack source to `src/ravintio-zero/`. The first suite run from the new folder failed 43 suites, and 19 prose baseline counts rose. The scan named neither cause.

## Deviations

None.

## Validation results

The full suite in a clean clone passes apart from three inherited failures. This step folds in backlog entry 0000419.

## Skipped phases

None
