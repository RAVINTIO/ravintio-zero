---
title: "Discovery - 0000493-driver-starts-after-restart"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000493-driver-starts-after-restart

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs beside source in `src/` (assumed without asking, per the start actions) |
| Git pre-flight | `feat/0000493-driver-starts-after-restart`, cut by the driver from `initiative/0000360-backlog-sweep` (initiative step, no human confirmation) |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.104.0`. Tag `v0.104.0` agrees. The step bump is `minor`, so the plan is 0.105.0. The merge queue writes the released version.
- Prior features (`plan/_archive/`): 47 earlier steps of initiative 0000360. The nearest are 0000491 (driver favours the critical path, v0.104.0) and 0000450 (coordinator status view, v0.97.0).
- Constraining ADRs: ADR-0302 (shared files), ADR-0310 (approved setup command), ADR-0314 (status view and events), and ADR-0322 (critical path).
- Component and data ownership: one component, `ravintio-zero`, which owns the driver, the watcher, and the control folders. The pack exists as two identical trees, `ravintio-zero/` and `src/ravintio-zero/`, and every earlier step edits both in one commit.

## Findings for this step

- Backlog entry 0000494 is the only input. Evidence: on 2026-11-10 step 25 merged at 20:01 and step 26 waited until 21:43 for steps 36, 38, and 39.
- Cause: in `schedule()` of `initiative-run.mjs`, `queueTask` calls `restartLine()` after a merge. A `Restart:` line calls `setStop()`. `startable()` then returns nothing, and the main loop waits for every running step. The driver then throws the stop line and exits 1. The coordinator restarts the driver only after that.
- The serial path (no `**Concurrency:**` field) holds no running steps, so it has nothing to hand over.
- A `Setup:` hit and a combined `Restart: Setup:` hit need the human or the coordinator to rerun setup. They keep the current stop.
- Control folders already carry the state a successor needs. `ready` holds the PR number. `running` holds the driver pid.
- The scheduler restart rule already treats `ready` as queue-without-session and `running` without `ready` as a session restart in the existing worktree. A successor that adopts a live session must not start a second one.
- `approvedSetup()` already fast-forwards the root to the merged ref. A successor needs the root on the merged ref, or it runs the old code.
- Queued items for step 48: none. Chart `## Decisions` rows for step 48: none. `## P1 skips` row for step 48: `no`.
- Pending migration 0009 reports in resume detection. It rewrites ADR layout, and `docs/adr/` already exists here. Not run in a step session.
- Steps 49, 50, 52, and 53 also edit the driver. They cover a dead lock, worktree entries, merged worktrees, and the restart exit code. This step leaves those topics alone.
