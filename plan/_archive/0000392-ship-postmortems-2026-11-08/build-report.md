# Build report - 0000392-ship-postmortems

Run speed: standard

| Phase | Agents | Tier | Wall clock (min) | Notes |
|-------|--------|------|------------------|-------|
| P0 Discovery | 0 | primary | 2 | Initiative step, design self-confirmed |
| P1 Plan | 0 | primary | 1 | Artifacts written inline |
| P2 Implement | 1 | primary and standard subagent | 17 | The queue wait ran in a subagent |
| P3 Validate | 0 | primary | see build log | Done inline |
| P4 Ship | 0 | primary | see build log | |

- Parallelism: one subagent built the queue wait (U2) while U1, U3, and U4 ran inline.
- Multi-task phases that ran sequentially: P1 wrote its artifacts inline. They share one design.
- Self-corrections: 1, avoidable. Three suites pinned lines the step edited, and the test impact scan has no cause for an edit to an existing line. Step 7 (0000361) covers it.
- Improvement, P1: list suites that compare an edited line by its text.
- Postmortems: `plan/postmortems/2026-11-08-step-16-tests-pinned-edited-lines.md`

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-001) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000392-ship-postmortems-2026-11-08.md
