# Build report: 0000573-require-unit-reports

**Run speed:** fast

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) | Parallel batches |
|-------|--------|-----------|----------------------|------------------|
| P0 Discovery | 0 | primary | 1 | 0 |
| P1 Plan | 0 | primary | 1 | 0 |
| P2 Implement | 0 | primary | 1344 | 0 |
| P3 Validate and Accept | 0 | primary | 23 | 0 |
| P4 Ship | 0 | primary | see build log | 0 |

## Parallelism

None applied. The three P2 units depend on each other, so the batches ran in sequence.

## Self-corrections

None.

## Improvement suggestions

- P2: the loop rules give a docs unit no RED or GREEN form. Backlog 0000410 tracks the fix. The ship check stopped the run on this gap.
- P2: the wall clock of 1344 minutes spans a session gap. The log shows no work for most of it.

Postmortems: `plan/postmortems/2026-11-15-docs-unit-no-red-green-marker.md`

Inherited failures:

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`
- `test-0000450-req-004-report-format.sh`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 1 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |
| Longest CI run (seconds) | 0 | 420 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| content | inline | 2 | 0 |
Retrospective: plan/retrospectives/0000573-require-unit-reports-2026-11-15.md
