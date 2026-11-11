---
title: "Discovery - 0000474-coordinator-shell-guidance"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000474-coordinator-shell-guidance

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior features beside source` |
| Git pre-flight | `feat/0000474-coordinator-shell-guidance, cut by the driver from the initiative branch` |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.97.0`
- Prior features (`plan/_archive/`): 0000505 (coordinator base merge, step 54), 0000450 (coordinator status view), 0000481 (regenerate shared files)
- Constraining ADRs: ADR-0315 (the base merge command never pushes). The guard rules stay: no variables, compound commands, or quoting allowed in `merge-guard` or `block-forced-add`.
- Component and data ownership: the pack `ravintio-zero/` owns the initiative skill, the roadmap standards, and the coordinator scripts.
- Backlog entry: 0000437. Shell snags cost time from 2026-11-08 to 2026-11-10.
- Existing scripts: `coordinator-pr-check.mjs` covers the overlap check. `initiative-queue.mjs` covers the queue. No script drains the queue or edits files in bulk.
- Queue items: none name step 41.
- Bump: minor, from the chart row (0.97.0 to 0.98.0 planned).
- `.feature-id` held the stale value `0000505-coordinator-branch-regenerate`. The step replaces it with its own id.
- Migration 0009: pending, left for the human. It needs a human y/n and is safe to skip.
