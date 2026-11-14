---
title: "Discovery - 0000547-step-merge-regenerates-index"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000547-step-merge-regenerates-index

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features. Assumed without asking. |
| Git pre-flight | `feat/0000547-step-merge-regenerates-index`, cut by the driver from the initiative ref in a step worktree |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.114.0`. The step bump is minor, so the plan version is `0.115.0`.
- Prior features (`plan/_archive/`): the latest is 0000536-pending-migrations-reach-the-human-early (2026-11-13).
- Constraining ADRs: ADR-0311 (conflict check before CI) and ADR-0313 (the queue regenerates shared files after every base merge). Neither conflicts.
- Component map: one component, `ravintio-zero`. Pack source lives in `src/ravintio-zero/` and the installed copy in `ravintio-zero/`.
- Backlog entry 0000517 is the only input. It names no schema change and no dependency.
- I-D Advance item 4 tells a step to merge `origin/initiative/{id}-{slug}` by hand when the PR conflicts. It says nothing about the backlog index.
- The `validate-branch` job in `.github/workflows/ravintio.yml` runs `backlog-index.mjs --check` as the step `Check the backlog index`. Shard jobs of `bash-suites` also fail on a stale index.
- The queue already rebuilds the index after its own base merges (see `## Shared files`).
