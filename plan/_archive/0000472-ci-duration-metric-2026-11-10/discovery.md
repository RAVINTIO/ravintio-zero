---
title: "Discovery - 0000472-ci-duration-metric"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000472-ci-duration-metric

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000472-ci-duration-metric`, cut from `initiative/0000360-backlog-sweep` at `f7573cde`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.87.0`. The chart bump for step 40 is `minor`.
- Prior features (`plan/_archive/`): 0000173 added `workflow-metrics.mjs`. 0000409 cut CI to 4m40s with shards. 0000470 is the latest archived run.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0306.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000436 (evidence row 15 of the initiative 0000360 retrospective): each merge waited about 16 minutes for CI. Feature 0000409 cut it to 4m40s. Nothing shows CI growth, so it shows only when someone feels it.
- `workflow-metrics.mjs` counts four marker types and compares each with a threshold in `workflow-governance-standards.md`. It has no CI duration metric.
- Wanted outcome: `workflow-metrics.mjs` reports CI duration per run, and a standard names a target.
- Backlog pickup: 0000436, named by the step 40 row. The entry widens no guard.

## Coaching record

None. An initiative step self-confirms its design.
