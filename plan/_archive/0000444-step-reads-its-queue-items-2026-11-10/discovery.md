---
title: "Discovery - 0000444-step-reads-its-queue-items"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000444-step-reads-its-queue-items

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000444-step-reads-its-queue-items`, cut from `initiative/0000360-backlog-sweep` by the driver in the `step-26` worktree. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.87.0`. The chart bump for step 26 is `minor`.
- Prior features (`plan/_archive/`): 0000442 added the ready file helper. 0000470 is the latest archived run.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0306.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000425 (evidence rows 8, 19, and 25 of the initiative 0000360 retrospective): steps missed queue items that named them.
- Step 13 read an empty worktree queue. Step 17 ran `cat` on item folders and never read `item.md`. Step 18 never read `narrow-brand-guard-self-entry`.
- The driver start prompt is `Run initiative step {n}` and names no item (`src/ravintio-zero/scripts/initiative-run.mjs`, `runStep`).
- Nothing compares the queue with the step diff before ship raises the PR.
- Wanted outcome: the start prompt lists the items that name the step. A ship check fails when a named item has no commit or report.
- Backlog pickup: 0000425, named by the step 26 row. The entry widens no guard.
- Queue now: `plan/.initiative-queue/rebase-step-25` names step 25. No item names step 26.
- Pending migration 0009 (ADRs in `docs/adr`) stays pending. It needs a human y/n. `docs/adr/` already holds the ADRs.
- The step edits `initiative-run.mjs`, so the driver takes the `Restart:` stop after this step merges. The chart pre-approves that.

## Coaching record

None. An initiative step self-confirms its design.
