# Changelog (0000563-test-impact-misses-output-readers, 15 Nov 2026)

**Feature:** Plan test impact misses suites that read driver output order
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The plan skill's Test impact scan has an `Output order` cause. It tells the plan author to list suites that match the text of a changed printed line and suites that read the last line. A new suite checks the cause in both pack trees.

## Why

A change to the driver output broke five suites that read the last line. The plan listed none of them, and the full suite found them after 25 minutes.

## Deviations

None.

## Validation results

The full suite in a clean clone passes apart from three inherited failures. This step folds in backlog entry 0000533.

## Skipped phases

None
