---
title: "Build Log - 0000379-parallel-steps-on-worktrees"
summary: "Working record of the pipeline run, maintained by the orchestrator."
---
# Build Log - 0000379-parallel-steps-on-worktrees

> Created at discovery (P0). Appended by the orchestrator at each phase boundary. Survives session changes.

## Header

| Field | Value |
|-------|-------|
| Feature ID | `0000379-parallel-steps-on-worktrees` |
| Pipeline start | `2026-11-07T17:00:18Z` |
| Tool | `Claude Code` |
| Primary model | `claude-sonnet-5-5` |
| Cheaper model | `claude-haiku-5-5` |
| Run speed | `standard` |

Run mode: autonomous (2026-11-07T17:00:18Z, initiative step 3)
Run speed: standard (2026-11-07T17:00:18Z)

---

## Phase Log

### P0: Discovery

| Field | Value |
|-------|-------|
| Start | `2026-11-07T17:00:18Z` |
| End | `2026-11-07T17:02:01Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-orchestrator |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | initiative step 3 of 21. Migrations 0004 and 0005 stay pending (Applies when is false in the pack source). |

Decision applied (initiative chart): Concurrency 3 [Decisions row, step 3]
Decision applied (initiative chart): worktree rule scoped to human sessions in standard-boot.md [Decisions row, step 3]
Scope Lock (happy path): Two pending steps in different lanes run at once in worktrees and both merge through the queue [source: draft-accepted (initiative)]
Scope Lock (first-run path): A chart with no Lane, After, or Concurrency runs one step at a time as before [source: draft-accepted (initiative)]
Scope Lock (error path): A Blocked: line in one running step stops new starts and the report names every step's state [source: draft-accepted (initiative)]
Scope Lock (cross-session continuity): Row statuses and the control area survive a driver restart and the driver reuses a running step's worktree [source: draft-accepted (initiative)]
Scope Lock complete. All four scenario paths captured.
Complete: P0 (2026-11-07T17:02:01Z)

---

### P1: Plan

| Field | Value |
|-------|-------|
| Start | `2026-11-07T17:02:01Z` |
| End | `2026-11-07T17:03:45Z` |
| Wall clock | 2 |
| Model tier | primary |
| Skills loaded | ravintio-plan |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | 7 requirements, 4 ADRs. Consistency check clean. Gate self-confirmed (initiative step). |

Gate accepted: draft-accepted (initiative) (2026-11-07T17:03:45Z)
Complete: P1 (2026-11-07T17:03:45Z)

---

### P2: Implement

| Field | Value |
|-------|-------|
| Start | `2026-11-07T17:03:45Z` |
| End | `2026-11-07T18:05:58Z` |
| Wall clock | 40 |
| Model tier | primary |
| Skills loaded | ravintio-implement |
| Agents spawned | 6 |
| MCP calls | 0 |
| Parallel task batches | 3 |
| Notes | Batches follow the Concurrency plan: U1 to U3, then U4, then U5 and U6. Tests written before code in each unit. |

Departure: Rework: REQ-004: test-0000378 AC-3 pinned Position 1, now 3 by design (2026-11-07T18:05:58Z)
Departure: tests/run-tests.sh allowlist gained helpers/scheduler-fixture.sh (2026-11-07T18:05:58Z)
Deviation: running and ready live in the control area, not the committed chart (ADR-001)
Complete: P2 (2026-11-07T18:05:58Z)

---

### P3: Validate and Accept

| Field | Value |
|-------|-------|
| Start | `2026-11-07T18:06:08Z` |
| End | `2026-11-07T19:07:25Z` |
| Wall clock | 5 |
| Model tier | primary |
| Skills loaded | ravintio-validate-and-accept |
| Agents spawned | 0 |
| MCP calls | 0 |
| Parallel task batches | 0 |
| Notes | Full suite green. Two self-corrections before the run (boot template cap, helper allowlist). |

Gate accepted: draft-accepted (initiative) (2026-11-07T19:07:25Z)
Complete: P3 (2026-11-07T19:07:25Z)
