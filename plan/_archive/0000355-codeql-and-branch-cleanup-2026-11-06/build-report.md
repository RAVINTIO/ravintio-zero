# Build report - 0000355-codeql-and-branch-cleanup

Run speed: standard

## Phases

| Phase | Agents | Model tier | Wall clock (minutes) |
|-------|--------|------------|----------------------|
| P0 Discovery | 0 | primary | 3 |
| P1 Plan | 0 | primary | 0 |
| P2 Implement | 0 | primary | 0 |
| P3 Validate and Accept | 0 | primary | 0 |
| P4 Ship | 0 | primary | 0 |

Wall clocks come from the recorded phase timestamps, which are coarse. Backlog entry 0000335 covers the cause.

## Parallelism

None used. P2 ran its units inline because each was a few lines in shared workflow files.

## Self-corrections

- REQ-004: two workflow tests counted one write scope and now count two. Avoidable: the plan's test impact scan can name the workflow cause, and this step adds that line.
- The chart status line carries a trailing comment. `assert.sh` now accepts it.

## Improvements

- P1: check a human-only setting before P2 starts (backlog entry 0000364).

Postmortems: none
## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-004) | 2 | ok |
| `Blocked:` stops | 1 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.

Retrospective: plan/retrospectives/0000355-codeql-and-branch-cleanup-2026-11-06.md
