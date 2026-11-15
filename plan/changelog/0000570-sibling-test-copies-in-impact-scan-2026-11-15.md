# Changelog (0000570-sibling-test-copies-in-impact-scan, 15 Nov 2026)

**Feature:** List sibling copies of a pinned test in the impact scan
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

The plan skill's `## Test impact scan` section now says to grep `ravintio-zero/tests/regression/` for a file with the same name as each listed test. It also says to list the match. A new suite checks the sentence and the scan size in both pack trees.

## Why

The plan for 0000389 named `test-0000034-req-003-atomic-settings-writes.sh` and missed its copy under `tests/regression/`. The full suite found the gap in P2.

## Deviations

The entry suggests a line in the scan. The scan held 21 lines, the cap in four suites. The sentence joins the existing scan paragraph, so no cap changed.

## Validation results

The full suite passes apart from three inherited failures. This step folds in backlog entry 0000407.

## Skipped phases

None
