---
title: "Discovery - 0000464-merge-queue-test-gaps"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000464-merge-queue-test-gaps

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds source |
| Git pre-flight | `feat/0000464-merge-queue-test-gaps`, cut from the initiative branch by the driver, clean tree |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.83.0`. The merge queue sets the released version at merge.
- Prior features: `plan/_archive/` holds runs through 0000462 (2026-11-10).
- Constraining ADRs: 0000378 ADR-001 (merge the base into the PR branch) and 0000454 (revert stale version commits). Both stay.
- Component map: one component, `ravintio-zero`. It owns `ravintio-zero/scripts/merge-queue.mjs` and its tests.
- Repo instructions: `ravintio-overrides/instructions/` holds a git-permissions file and two skill overrides.
- Backlog: entry 0000400 comes from the step row. A step runs no stale-entry review.
- Step row: step 36, `minor`, lane `tests`, after 31 and 35. Both have merged. P1 runs.
