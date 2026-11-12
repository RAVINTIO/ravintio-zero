---
title: "Discovery - 0000503-planned-restart-exit-code"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000503-planned-restart-exit-code

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000503-planned-restart-exit-code`, cut by the driver from the initiative branch. Clean tree. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.108.0`
- Prior features (`plan/_archive/`): step 52 (0000501, driver removes merged step worktrees) is the latest driver change.
- Constraining ADRs: ADR-0323 (handoff), ADR-0324 (dead lock), ADR-0326 (worktree sweep).
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000504 states the problem. At 00:29 on 2026-11-11 the driver printed `Restart:` after step 27 and exited 1. The host reported the background task as failed.
- `main()` in `src/ravintio-zero/scripts/initiative-run.mjs` exits 1 for every `Stop`. A `Restart:` line is a `Stop`, so it exits 1 like a `Blocked:` line.
- Four code paths build a `Restart:` line: the serial path (`Restart:` and `Restart: Setup:`) and the concurrent path through `restartLine()` and `setStop()`.
- The handoff line (`A new driver took over new starts.`) is not a stop. The old driver exits 0 with it, and that stays.
- The initiative skill says a `Restart:` line is not a failure. Its `## Stops` section opens with "exits non-zero" as a stop, so the two statements clash today.
- The watcher reads the driver lock and prints `event: driver exited`. It never sees the exit code, so it needs no change.
- Existing tests expect exit 1 on restart lines in `test-0000250-req-002`, `test-0000313-req-001`, `test-0000448-req-002`, and `test-0000493-req-001-003`. The step updates the ones that hit a `Restart:` line.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
- Migration 0009 is pending. The step skips it (see the build log).
