# Build report - 0000454-queue-failure-recovery

**Run speed:** standard

## Phases

| Phase | Agents | Model tier | Wall clock | Parallel batches |
|-------|--------|-----------|------------|------------------|
| P0 Discovery | 0 | primary | 2 min | 0 |
| P1 Plan | 0 | primary | 1 min | 0 |
| P2 Implement | 0 | primary | 26 min | 0 |
| P3 Validate and Accept | 1 | primary | 0 min | 0 |
| P4 Ship | 0 | primary | 0 min | 0 |

## Parallelism

None used. The three requirements edit one script and one suite, so no unit split. The two full suite runs overlapped in the background.

## Self-corrections

None.

## Improvement suggestions

- P2: start the post-change full suite as soon as the code lands. The 25-minute run set the wall clock.

## Postmortems

Postmortems: none

## Inherited failures

- `test-0000037-req-004-remove-old-folder.sh`
- `test-0000318-req-004-merge-guard-pinned.sh`

Offer a backlog entry for each. Neither is new to this run.

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

## Dispatch by class and tier

No dispatched units.

Retrospective: plan/retrospectives/0000454-queue-failure-recovery-2026-11-10.md
