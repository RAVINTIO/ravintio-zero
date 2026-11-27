---
title: "Discovery - 0000550-no-head-diffs-in-tests"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000550-no-head-diffs-in-tests

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside an archive in `plan/_archive/` |
| Git pre-flight | Branch `feat/0000550-no-head-diffs-in-tests`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.124.0`. This step plans a minor bump to `0.125.0`. The merge queue sets the released version.
- Prior features (`plan/_archive/`): 0000566, 0000565, 0000564 on 2026-11-15.
- Constraining ADRs: none read for this step.
- Component map: one component, `ravintio-zero`, source in `src/ravintio-zero/`, installed copy in `ravintio-zero/`.
- Repo instructions: git permissions, subagent decomposition, ship push and PR, standing setup approval.
