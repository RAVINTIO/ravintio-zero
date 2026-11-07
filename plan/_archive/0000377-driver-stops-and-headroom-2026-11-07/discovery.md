---
title: "Discovery - 0000377-driver-stops-and-headroom"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000377-driver-stops-and-headroom

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | `feat/0000377-driver-stops-and-headroom` cut from `initiative/0000360-backlog-sweep` (initiative step, I-C Run) |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.56.0`, last feature `0000359-safe-parallel-commits`
- Prior features (`plan/_archive/`): see archive. Latest is 0000359 (safe parallel commits).
- Constraining ADRs: none read for this step
- Component / data-ownership map: one component, `ravintio-zero` (pack). No data stores.
- Repo instructions (`ravintio-overrides/instructions/`): custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval
- Backlog entries for this step: 0000371, 0000370, 0000373
- Orchestrator `SKILL.md` is 8882 bytes under a 9000 byte cap
