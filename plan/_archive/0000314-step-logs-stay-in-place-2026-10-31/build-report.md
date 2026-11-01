# Build report - 0000314-step-logs-stay-in-place

Run speed was `fast`. The build log records 31 minutes of total wall clock.

## Phases

| Phase | Agents spawned | Model tier | Parallel batches | Wall clock (minutes) |
|-------|----------------|------------|------------------|----------------------|
| P0 Discovery | 0 | primary | 0 | 4 |
| P1 Plan | 0 | primary | 0 | 4 |
| P2 Implement | 0 | primary | 0 | 6 |
| P3 Validate and accept | 0 | primary | 1 | 5 |
| P4 Ship | 0 | primary | 0 | 11 |

Every phase has an End row, so no phase reads `not recorded`.

## Parallelism

- The chart asked for parallel units. No phase dispatched a subagent.
- P1, P2, and P4 ran sequentially. The three P2 units share two test files and a few lines of skill text, and each unit took under two minutes, so subagent overhead outweighed the gain.
- P3 ran the full suite in the background while verification and the security review ran inline.

## Self-corrections

None.

## Improvement suggestions

- P0: The build log took estimated phase times at first and needed correction at ship. Write the real time with `date -u` at each phase boundary.
- P2: A later step could dispatch units in parallel if the units touch separate files.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000314-step-logs-stay-in-place-2026-10-31.md
