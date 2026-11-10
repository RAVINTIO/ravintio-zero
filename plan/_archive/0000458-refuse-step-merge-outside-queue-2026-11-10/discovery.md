---
title: "Discovery - 0000458-refuse-step-merge-outside-queue"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000458-refuse-step-merge-outside-queue

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000458-refuse-step-merge-outside-queue`, cut from `initiative/0000360-backlog-sweep` at `a7a9a1b2`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.80.1`. The chart bump for step 33 is `minor`.
- Prior features (`plan/_archive/`): `0000043-autonomous-roadmaps` wrote `merge-guard`. `0000454-queue-failure-recovery` is the latest queue change.
- Constraining ADRs (unless superseded): ADR-0151 (agent squash-merge into roadmap branches) and ADR-0238 (coordinator PRs ride the existing merge-guard).
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Step 12 squash-merged its own PR #133 and bypassed the merge queue. The PR got no version, no tag, and a `pending` chart row (evidence row 7).
- `merge-guard.mjs` allows any plain `--squash` merge whose PR base starts with `initiative/`. It reads no environment.
- The concurrent driver sets `RAVINTIO_INITIATIVE_QUEUE=1` for every step session. The driver runs `merge-queue.mjs` as its own process, so no step session needs to merge.
- The carve-out text in `roadmap-standards.md`, the ship skill, `orchestrator-phase-invocation.md`, `hook-enforcement.md`, and `docs/architecture-overview.md` lets the agent squash its own feature PR. That overlaps with the queue.
- The change narrows the guard. It widens nothing. The queue merge must still pass, and a test must cover it.
- Backlog pickup: 0000431, named by the step 33 row.
- Queue: no item names step 33 (`$RAVINTIO_INITIATIVE_ROOT/plan/.initiative-queue/` does not exist).

## Coaching record

None. An initiative step self-confirms its design.
