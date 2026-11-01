# Build report - 0000313-driver-setup-stop

Run speed was `fast`. The build log records 51 minutes of total wall clock.

## Phases

| Phase | Agents spawned | Model tier | Parallel batches | Wall clock (minutes) |
|-------|----------------|------------|------------------|----------------------|
| P0 Discovery | 0 | primary | 0 | 4 |
| P1 Plan | 0 | primary | 0 | 4 |
| P2 Implement | 3 | primary | 1 | 17 |
| P3 Validate and accept | 0 | primary | 0 | 11 |
| P4 Ship | 1 | primary | 1 | 12 |

Every phase has an End row, so no phase reads `not recorded`.

The phase rows add up to 48 minutes. The build log summary reports 51 minutes. The log does not explain the difference.

## Parallelism

- P2 dispatched one fast batch. Units U1, U2, and U3 went out in one message to three subagents.
- P4 dispatched one fast batch. Step 5 ran in a cheaper-tier subagent, and Step 6 ran inline.
- P1 ran sequentially. Its artifacts cross-reference each other, so it wrote them inline.
- P3 ran sequentially. Its checks, execution run, and security review read the same four files, so it ran them inline.

## Self-corrections

- P3, cycle 1: the old-name guard failed on build log lines 38 and 39. The notes named the old product and draft file names. The fix reworded them, and the guard passed.
  - Avoidable: yes. The guard checks for old names, so the notes could have avoided them when first written.

## Improvement suggestions

- P2: Record each subagent's model name in the phase row. The row shows only the primary tier.
- P3: Run the old-name guard on build log notes before writing them to the log.
- P4: Record the cheaper-tier subagent's model name in the phase row. The row shows only the primary tier.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000313-driver-setup-stop-2026-10-31.md
