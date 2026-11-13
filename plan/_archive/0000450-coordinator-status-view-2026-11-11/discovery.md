---
title: "Discovery - 0000450-coordinator-status-view"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000450-coordinator-status-view

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds the pack source |
| Git pre-flight | Branch `feat/0000450-coordinator-status-view`, cut by the driver from the initiative branch. Clean tree. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.94.0`. Last version on the initiative branch comes from `product.yml`: `0.94.0`.
- Prior features (`plan/_archive/`): 0000485 (colliding ids, 2026-11-11), 0000483 (mergeability before CI wait, 2026-11-11), 0000448 (setup command, 2026-11-11).
- Constraining ADRs: 0309 to 0312 (merge queue, setup command, mergeability, id collisions). None conflicts with this feature.
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`, installed copy in `ravintio-zero/` synced with `sync-installed.mjs`.
- Migration 0009 is pending and needs a human answer. The step leaves it pending.
- Backlog 0000428 is the only entry for this step. The queue holds no item for step 29.
- Existing code: `initiative-watch.mjs` (520 lines) reads control files and prints events. `initiative-run.mjs` (1321 lines) prints `I-C Run: Stopping:` and holds the queue failure reason until exit.
