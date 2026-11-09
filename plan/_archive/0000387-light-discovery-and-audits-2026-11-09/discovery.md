---
title: "Discovery - 0000387-light-discovery-and-audits"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000387-light-discovery-and-audits

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` present beside source |
| Git pre-flight | `feat/0000387-light-discovery-and-audits`, cut by the driver from `initiative/0000360-backlog-sweep` |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.66.0`. Planned version: `0.67.0` (minor bump from the step row). The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000384-plan-checks (step 8), 0000388-replies-and-questions (step 12), 0000393-session-integrity-and-guards (step 17).
- Constraining ADRs: none that bear on this step.
- Component map: one component, `ravintio-zero`. Pack source sits at `ravintio-zero/` in this step's layout.
- Track: full (initiative step, chart-approved brief from backlog entries 0000281, 0000284, 0000348, 0000328, 0000329)
- Repo instructions: custom-001, custom-002, custom-004, custom-006 in `ravintio-overrides/instructions/`.
- Pending migrations 0004, 0005, 0008, 0009: their Applies when conditions are false here, so they stay pending.
- Queue: `ci-gate-step-11` read and written to `plan/current/coordinator-instruction-ci-gate.md`.
