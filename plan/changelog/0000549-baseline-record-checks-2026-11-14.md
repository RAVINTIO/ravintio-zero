# Changelog (0000549-baseline-record-checks, 14 Nov 2026)

**Feature:** Baseline record checks its input and its file
**Version:** set by the merge queue at merge
**PR:** 218

## What changed

- `baseline-failures.mjs record` exits 2 and writes no file when the runner output has no `Feature suites:` line.
- `baseline-failures.mjs check` exits 1 and prints `no baseline recorded` on stderr when the baseline file is missing.
- The suite `test-0000385-req-002-baseline-failures.sh` covers both cases. Its AC-3 pin, which called a missing file an empty baseline, now expects the error.
- `docs/architecture-overview.md` and the tests README describe the new behaviour.
- The step closes backlog entries 0000525 and 0000515.

## Why

A clean-clone run that ended early gave `record` output with no failure list. The script wrote `None.` and exited 0. P3 then flagged inherited failures as new. A missing baseline file did the same through `check`.

## Deviations

None.

## Validation results

- The suite `test-0000385-req-002-baseline-failures.sh` passes with 20 checks.
- The full suite in a clean clone shows 449 feature suites passed and 3 failed. The 3 failures also fail in a clean clone of the base commit.
- The verification report and security report show no failed criterion and no critical or high finding.

## Skipped phases

None.
