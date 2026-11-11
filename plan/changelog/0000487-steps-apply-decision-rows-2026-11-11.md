# Changelog (0000487-steps-apply-decision-rows, 11 Nov 2026)

**Feature:** Steps apply the chart's Decisions rows
**Version:** set by the merge queue at merge
**PR:** 

## What changed

- A new module, `decision-rows.mjs`, lists the chart's `## Decisions` rows that name a step. It expands ranges such as `25-41` and comma lists, and it skips rows whose Fork is `none`.
- `build-log-check.mjs` gains check 9. It finds the step from the log's Feature ID and fails a log with no `Decision applied` or `Decision not applicable` line for an applicable row.
- The P0 start actions gain step 16 with rule anchor `p0-start-decisions`. A step lists its rows at the start of P0 and logs one line for each.
- Rule `icrun-decision-row` in `roadmap-standards.md` names the lookup and the check.
- Three new suites, `test-0000487-req-001-decision-rows.sh`, `test-0000487-req-002-check-decisions.sh`, and `test-0000487-req-003-p0-text.sh`, cover the module, the check, and the text.
- ADR 0314 records the decision.

## Why

Step 40 ignored the Decisions row for steps 25 to 41. It spent about 30 minutes on a baseline run and a full suite run that the row had removed. No code read the table, so nothing caught the miss.

## Deviations

- P2 ran inline without subagents, because the units share one module.
- The check requires a log line only. It does not judge whether the step applied the answer.

## Validation results

- The module suite passes 11 of 11 checks, the check suite 10 of 10, and the text suite 7 of 7. Each failed before its change.
- The full suite result is in the verification report.

## Skipped phases

None.
