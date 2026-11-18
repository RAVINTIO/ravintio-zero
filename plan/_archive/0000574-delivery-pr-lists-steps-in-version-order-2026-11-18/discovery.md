---
title: "Discovery - 0000574-delivery-pr-lists-steps-in-version-order"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000574-delivery-pr-lists-steps-in-version-order

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds earlier runs beside src/` |
| Git pre-flight | `feat/0000574-delivery-pr-lists-steps-in-version-order, cut by the driver from the initiative branch` |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.142.0`. The step bump is minor, so the plan version is `0.143.0`. The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000378 made `reshape-initiative.mjs` replay steps in ascending `Version` order. 0000353 added the script.
- Constraining ADRs: none read for this step.
- Component map: one component, `ravintio-zero`. The step edits `reshape-initiative.mjs`, `roadmap-standards.md`, and one new test. It mirrors each edit in `src/ravintio-zero/`.
- Backlog entry 0000543: rule 6 of I-E Delivery names no order, and no script prints the step table. The script already sorts steps by ascending version at line 149.
- Migrations: none pending. The files in `ravintio-zero/migrations/` apply to earlier layouts.
- Queue: no item names step 30.
