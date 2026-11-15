# Changelog (0000550-no-head-diffs-in-tests, 15 Nov 2026)

**Feature:** No HEAD diffs in tests
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

`testing-standards.md` holds the rule `tests-no-head-diff`. A test never compares the working tree with `HEAD` or another moving ref. The suite `test-0000550-req-002-no-head-diffs.sh` scans every suite under `tests/` and fails one that runs `git diff` against `HEAD`, `HEAD~n`, `HEAD^`, `@`, `ORIG_HEAD`, or `FETCH_HEAD`. It plants six bad files and four good files to prove the scan. This step folds in backlog entry 0000416.

## Why

After someone commits the work, a diff against `HEAD` is empty and the test passes with no check. Two checks in `test-0000391-req-008-standard-text.sh` did this, and no standard named the pattern.

## Deviations

None.

## Validation results

The impact suites and the new suite pass. The full suite result is in the build log.

## Skipped phases

None
