# Changelog (0000438-add-step-writes-full-feature-id, 10 Nov 2026)

**Feature:** Add-step writes the full feature id
**Version:** set by the merge queue at merge
**PR:** 0

## What changed

- `initiative-add-step.mjs` writes `{id}-{slug}` in the `Feature id` cell, and in the `Source feature` line of the backlog entry it files.
- `initiative-chart.mjs` exports `FEATURE_ID`. The helper checks the new id against it before it writes.
- A new test, `test-0000438-req-001-full-feature-id.sh`, runs a chart the helper wrote through the driver pattern. It also fails when the driver pattern differs from `FEATURE_ID`.
- `test-0000399-req-002-add-step.sh` expects the full id in the Steps row.
- This step pulls in backlog entry 0000423 and deletes it.

## Why

On 2026-11-10 the driver stopped with "step 22 has an invalid feature id" until a person fixed the row by hand. The helper and the driver each defined the id shape and shared no pattern.

## Deviations

- The driver keeps its own `FEATURE` constant. An edit to `initiative-run.mjs` triggers the restart stop, and steps 24 to 27 edit that file next. A test pins the two patterns instead.
- Both implementation units ran inline, with no subagents. The change is two small edits and one test.
- No ADR. The decision touches one component and no stack choice.

## Validation results

- Clean-clone suite: 381 feature suites passed and 2 failed. Both failures also fail on the base commit. 19 regression suites passed.
- Worktree suite: 383 passed, 0 failed.
- The helper ran in a scratch folder and wrote `0000900-check-run`, which the driver pattern accepts.
- Security review: 0 critical and 0 high findings.

## Skipped phases

None.
