---
title: "Build Report - 0000317-block-forced-adds"
summary: "Phase times, parallelism, and self-corrections for the run."
---
# Build Report - 0000317-block-forced-adds

**Run speed:** fast

| Phase | Wall clock (min) | Agents | Model tier | Parallel batches |
|-------|------------------|--------|------------|------------------|
| P0 Discovery | 1 | 0 | primary | 0 |
| P1 Plan | 1 | 0 | primary | 0 |
| P2 Implement | 25 | 0 | primary | 0 |
| P3 Validate and Accept | 9 | 0 | primary | 0 |
| P4 Ship | 0 | 0 | primary | 0 |

Phase times come from commit timestamps.

## Parallelism

The run ran every phase inline, and the standing override asks for decomposition. P2 units U1 and U2 had no dependency but both edited shared test helpers and settings suites. Each unit was about 150 lines of change, so a subagent context would have cost more than it saved. P3 ran verification and the security review inline after the full suite passed.

## Self-corrections

| Cycle | Phase | Cause | Avoidable |
|-------|-------|-------|-----------|
| 1 | P2 | Seven suites, two regression copies, and a fixture counted the hook entries or listed the guard modules. The plan's test-impact scan named four of them. | Yes. The same miss happened in step 4. A grep over every suite for `merge-guard` would have found all. |
| 2 | P2 | `test-0000036-req-004-setup-ps1-install` read a shared expected-entry list in `helpers/setup-workspace.ps1`. | Yes. A grep of the `.ps1` helpers for the module list would have found it. |

Two more small stops cost no cycle. The commit-msg hook rejected a 79-character subject, and `merge-guard` blocked a shell command that held merge text.

## Improvement suggestions

- P1: The test-impact scan should grep every suite and helper for a module name that setup wires.
- P2: Run each edited suite and its `.ps1` twin alone before the full run.
- P2: Write a file that quotes a blocked command with the Write tool, not a shell heredoc.

Postmortems: none

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 0 | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
Retrospective: plan/retrospectives/0000317-block-forced-adds-2026-10-31.md
