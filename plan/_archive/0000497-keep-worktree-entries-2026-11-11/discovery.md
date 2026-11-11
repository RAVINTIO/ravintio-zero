---
title: "Discovery - 0000497-keep-worktree-entries"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000497-keep-worktree-entries

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the component. This is the only signal. |
| Git pre-flight | Branch `feat/0000497-keep-worktree-entries`, cut by the driver from the initiative branch. Clean tree. |
| Skills inbox | empty |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.106.0`
- Prior features (`plan/_archive/`): step 49 (0000495, driver clears a dead lock) is the latest.
- Constraining ADRs: ADR-0324 (dead lock). ADR-0323 (handoff). Neither covers worktree removal.
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`. The installed copy `ravintio-zero/` comes from `sync-installed.mjs`.

## Findings for this step

- Backlog entry 0000498 states the problem. Step 40 filed entry 0000480 in its worktree and left it untracked. The worktree removal would have deleted it, and the coordinator saved a copy by hand.
- `queueTask()` in `src/ravintio-zero/scripts/initiative-run.mjs` calls `removeWorktree(root, n)` before it runs the merge queue. That function runs `git worktree remove --force`, which deletes untracked files.
- The entry's suggested action has two parts. The driver checks untracked files under `plan/backlog/` before it removes a worktree. The ship skill checks that the step committed every entry it filed.
- Docs that describe the removal: the header comment of `initiative-run.mjs` and `roadmap-standards.md`.
- Schema, dependency, and guard checks: the step changes no schema, adds no dependency, and widens no hook guard.
