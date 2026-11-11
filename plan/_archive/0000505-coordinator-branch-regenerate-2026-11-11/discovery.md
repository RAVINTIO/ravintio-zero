---
title: "Discovery - 0000505-coordinator-branch-regenerate"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000505-coordinator-branch-regenerate

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior features beside source` |
| Git pre-flight | `feat/0000505-coordinator-branch-regenerate, cut by the driver from the initiative branch` |
| Skills inbox | `empty` |
| Track | `light` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.95.0`
- Prior features (`plan/_archive/`): 0000481 (regenerate after every base merge, step 42), 0000456 (shared-file resolution on conflict)
- Constraining ADRs: ADR-0302 (queue resolves allowlisted shared files on conflict), ADR-0313 (regenerate in a separate commit)
- Component and data ownership: the pack `ravintio-zero/` owns `shared-files.mjs`, `merge-queue.mjs`, and `coordinator-pr-check.mjs`
- Backlog entry: 0000506. The coordinator merged the initiative branch into a coordinator branch and hit a conflict in `plan/backlog/index.md`. No command resolves generated files there.
- Queue items: none name step 54.
- Bump: minor, from the chart row.
- Migration 0009: pending, left for the human.
