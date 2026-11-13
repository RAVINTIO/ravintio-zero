---
title: "Discovery - 0000446-drain-ready-prs-after-a-stop"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000446-drain-ready-prs-after-a-stop

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` holds a version |
| Git pre-flight | `feat/0000446-drain-ready-prs-after-a-stop`, cut by the driver from the initiative branch. No human is present to confirm. |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.90.0`. The step bump is `minor`, so the merge queue sets `0.91.0` at merge.
- Prior features (`plan/_archive/`): earlier steps of initiative 0000360, such as 0000442 and 0000444.
- Constraining ADRs: 0000379 ADR-002 (concurrent scheduler) applies to the driver loop.
- Component and data ownership: the pack source `ravintio-zero/` owns the driver, the merge queue, and the roadmap standards.

## Brief source

- Backlog entry 0000426, from the initiative row for step 27.
- The gap sits in `schedule()` of `ravintio-zero/scripts/initiative-run.mjs`. The loop condition `!queueFailed` holds back every ready PR after one queue failure.
- The chart row in `## P1 skips` says `no` for step 27, so P1 runs.
- The queue holds no item for step 27. The item `rebase-step-25` names step 25.
- Migration 0009 is pending and stays pending. See the build log.
