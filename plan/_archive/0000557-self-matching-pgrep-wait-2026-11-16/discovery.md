---
title: "Discovery - 0000557-self-matching-pgrep-wait"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000557-self-matching-pgrep-wait

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/` holds source |
| Git pre-flight | `feat/0000557-self-matching-pgrep-wait`, cut by the driver from the initiative branch. No human confirmation in an initiative step. |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.132.0`. The step bump is minor and the merge queue writes the released version.
- Prior features (`plan/_archive/`): latest are 0000556 and 0000569 (2026-11-15).
- Constraining ADRs: none read for this change.
- Component map: the `ravintio-zero` pack. Source lives in `src/ravintio-zero/` and mirrors to `ravintio-zero/`.
- Source entry: backlog 0000532, folded into the brief.
- Queue: `plan/.initiative-queue/` is absent. No item names step 13.
- Finding: no skill or standard names `pgrep` today. The P0 start actions (step 15) and `ravintio-validate-and-accept` (line 153) start a suite in the background and give no wait rule.
