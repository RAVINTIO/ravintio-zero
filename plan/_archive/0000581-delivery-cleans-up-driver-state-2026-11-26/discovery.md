---
title: "Discovery - 0000581-delivery-cleans-up-driver-state"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000581-delivery-cleans-up-driver-state

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` beside source in `src/` |
| Git pre-flight | `feat/0000581-delivery-cleans-up-driver-state`, cut by the driver from the initiative branch. Initiative step 37. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.150.0`. The step bump is minor, so the plan version is `0.151.0`.
- Prior features: `0000583-step-temp-cleanup-after-merge` (2026-11-26), `0000501-remove-merged-worktrees` (driver sweep at start).
- Constraining ADRs: `0326-driver-sweeps-merged-worktrees` says a kept worktree never stops the run. The 0000583 rule says no pack script deletes a path by name in a shared folder.
- Component map: one component, `ravintio-zero`. The pack lives in `src/ravintio-zero/` and mirrors to `ravintio-zero/`.
- Source: I-E Delivery in `ravintio-zero/standards/roadmap-standards.md` (line 697) and the `## I-E Delivery` section of `ravintio-zero/skills/ravintio-initiative/SKILL.md` list seven steps and a five-item final report. Neither names the driver state. `initiative-status.mjs` reads `plan/.initiative-control/step-{n}/` and `plan/.initiative-logs/`, so stale files there skew its counts for the next chart.
- Backlog entry: `0000582`, folded into the brief and deleted with the index regenerated.
- Queue: no `plan/.initiative-queue/` items name step 37.
- Decisions: only row `1-38` (a docs unit logs `RED:` and `GREEN:` with 0000410) applies.
- Baseline: the clean-clone run started at 2026-11-26T10:01:40Z. The sandbox blocks `mktemp` in `/var/folders` and writes to `/`, so some suites fail for that reason.
