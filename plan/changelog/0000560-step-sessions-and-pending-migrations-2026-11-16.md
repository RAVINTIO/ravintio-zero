# Changelog (0000560-step-sessions-and-pending-migrations, 16 Nov 2026)

**Feature:** Step sessions meet pending migrations
**Version:** set by the merge queue at merge
**PR:** pending

## What changed

A new suite, `test-0000560-req-001-ledger-rows-with-detect.sh`, plants each ledger row kind beside a true and a false Detect line. It checks the pending line that `resume-detect.mjs` prints. The step also removes backlog entry 0000403.

## Why

Entry 0000403 asked for a ledger skip and a step rule. 0000399 and 0000320 shipped the skip, and 0000536 shipped the step rule. No test pinned the `not applicable` rule that the chart keeps, so a change to it would pass the suite.

## Deviations

The step changes no code in `resume-detect.mjs`. The chart row said to build only the remaining gap, and the gap was the missing test.

## Validation results

The full suite passes apart from the inherited `test-0000037-req-004-remove-old-folder.sh`, `test-0000318-req-004-merge-guard-pinned.sh`, and `test-0000450-req-004-report-format.sh`. This step folds in backlog entry 0000403.

## Skipped phases

None
