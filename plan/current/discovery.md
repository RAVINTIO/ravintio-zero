---
title: "Discovery - 0000545-clear-feature-id-at-ship"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000545-clear-feature-id-at-ship

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000545-clear-feature-id-at-ship`, cut from the initiative branch by the driver. Skipped for an initiative step. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.114.0`
- Prior features (`plan/_archive/`): many, latest 0000378 onward. Not read in full.
- Constraining ADRs: none read for this change.
- Component / data-ownership map: component `src/ravintio-zero/` owns the pack. `ravintio-zero/` mirrors it.
- Tracked file: `plan/.feature-id` holds `0000536-pending-migrations-reach-the-human-early`, a stale id.
- Writers and readers of `plan/.feature-id`: `resume-detect.mjs`, `gate-write.mjs`, `orchestrator-resume-detection.md`, `pipeline-reference.md`, and three tests.
- Ship Step 8 deletes four sentinels and leaves `plan/.feature-id`.
- `shared-files.mjs` has no rule for `plan/.feature-id`.
