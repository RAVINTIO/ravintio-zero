---
title: "Discovery - 0000454-queue-failure-recovery"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000454-queue-failure-recovery

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` beside source in `src/` |
| Git pre-flight | `feat/0000454-queue-failure-recovery`, cut by the driver from the initiative ref in a step worktree |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.77.1`. Step 22 merged as v0.77.1.
- Prior features (`plan/_archive/`): 0000421 (2026-11-10), 0000420 (2026-11-10), 0000411 (2026-11-09), 0000409 (2026-11-09), 0000405 (2026-11-08), and earlier steps of initiative 0000360.
- Constraining ADRs: `docs/adr/0260-merge-queue-merges-not-rebases.md`. The queue merges the base into the PR branch and never rewrites pushed history.
- Component and data-ownership map: `ravintio-zero` owns `merge-queue.mjs` and its tests. Source is `src/ravintio-zero/`. `ravintio-zero/` is an installed copy that `sync-installed.mjs` refreshes.
- Repo instructions: custom-001 (git), custom-002 (subagent decomposition), custom-004 (ship), custom-006 (setup refresh).
- Queue items for step 31: none. The one item in `plan/.initiative-queue/` names step 34.
- Pending migration: 0009. It asks the human to proceed, so a step session leaves it pending.
- Step brief source: backlog entry 0000429, queue failure recovery. Related entry 0000400 (step 36) covers the rerun test only.
