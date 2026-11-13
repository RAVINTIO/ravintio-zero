---
title: "Discovery - 0000509-clear-merged-ready-files"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000509-clear-merged-ready-files

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000509-clear-merged-ready-files`, cut by the driver from the initiative branch. Clean tree. It holds one earlier commit that files backlog entry 0000530. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.110.0`
- Prior features (`plan/_archive/`): step 52 (0000501, driver removes merged step worktrees) is the closest driver change.
- Constraining ADRs: ADR-0326 (worktree sweep), ADR-0325 (kept worktrees), ADR-0323 (handoff).
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000510 states the problem. On 2026-11-11 the coordinator removed 7 `ready` files of merged steps by hand, for steps 10, 11, 13, 16, 18, 20, and 34.
- `schedule()` in `src/ravintio-zero/scripts/initiative-run.mjs` skips `readControl()` for a merged step. It never looks at that step's control folder.
- The queue deletes the whole control folder after it merges a step. A step that merged by hand, or under an earlier driver, keeps its `ready` file.
- `sweepMergedWorktrees()` (ADR-0326) is the model. It runs once at start, never when the driver takes over from another (`--handoff`), and never stops the run.
- Docs that describe the rule: the header comment of `initiative-run.mjs` and the "Concurrent steps" section of `roadmap-standards.md`.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
- Migration 0009 is pending. The step skips it (see the build log).
