---
title: "Discovery - 0000440-driver-reads-reply-blocks"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000440-driver-reads-reply-blocks

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs. Only signal. |
| Git pre-flight | `feat/0000440-driver-reads-reply-blocks`, cut from the initiative branch by the driver. Clean tree. |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.77.1`
- Prior features (`plan/_archive/`): latest are 0000421 and 0000420, both 2026-11-10
- Constraining ADRs: none touch the driver block read
- Component map: the pack is the only component. The driver is `ravintio-zero/scripts/initiative-run.mjs`.
- Pending migration 0009 needs a human `Proceed? (y/n)`. Left pending.
- Backlog source: 0000413. No queue item names step 24.
