---
title: "Discovery - 0000583-step-temp-cleanup-after-merge"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000583-step-temp-cleanup-after-merge

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` beside source in `src/` |
| Git pre-flight | `feat/0000583-step-temp-cleanup-after-merge`, cut by the driver from the initiative branch. Initiative step 38. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.145.0`. The step bump is minor, so the plan version is `0.146.0`.
- Prior features: `0000576-phase-start-time-at-phase-start` (2026-11-18), `0000501-remove-merged-worktrees` (driver sweep at start).
- Constraining ADRs: `0326-driver-sweeps-merged-worktrees` (never stop the run on a kept worktree).
- Component map: one component, `ravintio-zero`. The pack lives in `src/ravintio-zero/` and mirrors to `ravintio-zero/`.
- Source: `ravintio-zero/scripts/initiative-run.mjs` removes the step worktree before the queue runs (`removeWorktree`) and the control folder after the merge (`removeControl`). It never removes `/tmp/step{n}*` paths or extra worktrees.
- Leaks: suites `0000169-req-004`, `0000245-req-002`, `0000151-req-005`, `0000171-req-004` already hold an `EXIT` trap. A stopped suite (SIGTERM, SIGINT) skips it. `0000029-req-001-003` has no trap. `helpers/git-isolation.sh` leaves `ravintio-gitconfig.*` when a caller never runs `remove_git_isolation`.
- Backlog entry: `0000584`, folded into the brief and deleted with the index regenerated.
- Queue: no `plan/.initiative-queue/` items name step 38.
