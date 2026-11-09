# Build report - 0000384-plan-checks

**Run speed:** standard

## Phases

| Phase | Agents | Wall clock (min) | Notes |
|-------|--------|------------------|-------|
| P0 Discovery | 0 | 2 | Self-confirmed from the initiative chart |
| P1 Plan | 0 | 2 | Ran inline, the artifacts cross-reference each other |
| P2 Implement | 7 | see build log | Batch 1 ran four subagents, batch 2 ran one subagent and one inline unit, batch 3 ran one fix subagent and inline docs |
| P3 Validate | 0 | see build log | Full suite plus per-criterion runs |
| P4 Ship | 0 | see build log | No version bump (merge queue) |

All seven subagents ran on the primary tier (`sonnet`). No cheaper tier was dispatched.

## Parallelism

- Batch 1 ran U1 to U4 at once. Batch 2 ran U6 as a subagent while U5 ran inline.
- The fix of ten history-scanning suites ran as one subagent after the full suite failed.

## Self-corrections

| Cycle | Cause | Avoidable |
|-------|-------|-----------|
| 1 | U1 fixtures in `test-0000201-req-003` held no docs unit for check 10 | No, the check is new |
| 2 | Two wording tests flagged restored ADR history | Partly. The plan could have listed the history-scanning suites in the test impact table. |
| 3 | Ten more suites flagged `docs/adr/` as live files | Partly. Same cause, the scan grep missed them. |

## Improvement suggestions

- P1: the Test impact scan should grep for suites that exclude `plan/_archive/` when a run moves archive content.
- P2: a unit that moves files into a new folder should name the suites that scan live files in its Test impact row.
- P2: the first subagent report from U3 read `placeholder`. The orchestrator verified the files on disk before it counted the unit done.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000384-plan-checks-2026-11-08.md
