---
title: "Discovery - 0000481-regenerate-after-every-merge"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000481-regenerate-after-every-merge

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior features beside source` |
| Git pre-flight | `feat/0000481-regenerate-after-every-merge, cut by the driver from the initiative branch` |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.91.0`
- Prior features (`plan/_archive/`): 0000456 (shared-file resolution on conflict, step 32), 0000378 (merge-time versioning)
- Constraining ADRs: 0000456 ADR-0302 (queue resolves allowlisted shared files on conflict)
- Component / data-ownership map: the pack `ravintio-zero/` owns `merge-queue.mjs` and `shared-files.mjs`
- Backlog entry: 0000482. A clean base merge left `plan/backlog/index.md` stale and CI failed (evidence row 30).
- Queue items: none name step 42.
- Bump: minor, from the chart row.
