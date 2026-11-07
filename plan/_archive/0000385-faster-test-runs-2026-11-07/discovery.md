---
title: "Discovery - 0000385-faster-test-runs"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000385-faster-test-runs

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `product.yml` holds a version |
| Git pre-flight | `feat/0000385-faster-test-runs`, cut by the driver from `initiative/0000360-backlog-sweep` |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.60.0`
- Prior features (`plan/_archive/`): steps 1 to 4 of this initiative, merged as v0.57.0 to v0.60.0
- Constraining ADRs: none read for this step
- Component / data-ownership map: one component, `ravintio-zero`, no data store
- Repo instructions (`ravintio-overrides/instructions/`): local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval
- Queue (`plan/.initiative-queue/`): one item, and it names step 5
