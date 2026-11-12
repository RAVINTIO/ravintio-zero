---
title: "Discovery - 0000501-remove-merged-worktrees"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000501-remove-merged-worktrees

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000501-remove-merged-worktrees`, cut by the driver from the initiative branch. Clean tree. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.107.0`
- Prior features (`plan/_archive/`): step 50 (0000497, driver keeps uncommitted entries from a worktree) is the latest driver change.
- Constraining ADRs: ADR-0325 (kept worktrees), ADR-0323 (handoff), ADR-0324 (dead lock).
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000502 states the problem. On 2026-11-11 `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08.
- `queueTask()` in `src/ravintio-zero/scripts/initiative-run.mjs` calls `removeWorktree(root, n)` only for a step that reaches the queue in the current driver run. A step that merged under an earlier driver, by hand, or with its removal skipped keeps its worktree for good.
- `schedule()` already reads the chart, knows which steps have merged, and reads each step's control folder. It never looks at a worktree of a merged step.
- `keepUntrackedEntries()` (ADR-0325) already refuses to delete untracked backlog entries. The sweep reuses it.
- Docs that describe the removal: the header comment of `initiative-run.mjs` and the "Concurrent steps" section of `roadmap-standards.md`.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
- Migration 0009 is pending. The step skips it (see the build log).
