# Build report - 0000386-unit-dispatch

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|-----------|----------------------|
| P0 Discovery | 0 | primary | 2 |
| P1 Plan | 0 | primary | 3 |
| P2 Implement | 3 | primary | 34 |
| P3 Validate and Accept | 0 | primary | 0 |
| P4 Ship | 0 | primary | 1 |

## Parallelism

P2 ran batch 1 (U-001, U-002, U-003) as three parallel track subagents. U-004 ran inline after them. P0, P1, and P3 ran inline because their artifacts share one analysis.

## Self-corrections

- 1. A pinned `Done:` line in `test-0000043-req-012-progress-markers-and-resume.sh` changed with the intended edit. Not avoidable.
- Two wall clock rows needed a manual correction. Avoidable: compute the row from the clock.

## Improvement suggestions

- P2: give a unit with no test a valid `Done:` form (backlog entry 0000410).

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Offer: file a backlog entry for each. The step did not file them.

Retrospective: plan/retrospectives/0000386-unit-dispatch-2026-11-09.md

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

| Class | Tier | Units | Rework |
|-------|------|-------|--------|
| code | primary | 3 | 0 |
| unclassified | unclassified | 1 | 0 |
