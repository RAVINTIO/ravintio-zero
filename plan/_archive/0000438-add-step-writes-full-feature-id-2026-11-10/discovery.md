---
title: "Discovery - 0000438-add-step-writes-full-feature-id"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000438-add-step-writes-full-feature-id

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `src/` holds the source |
| Git pre-flight | `feat/0000438-add-step-writes-full-feature-id`, cut by the driver from the initiative branch (I-C Run) |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.77.1`. Step bump is patch, so the merge queue sets 0.77.2.
- Prior features (`plan/_archive/`): latest are 0000421-initiative-retrospective (2026-11-10) and 0000420-version-both-copies (2026-11-10).
- Constraining ADRs: none read for this change. The fix touches one script and one test.
- Component map: one component, `ravintio-zero`. Source in `src/ravintio-zero/`, installed copy in `ravintio-zero/` (see `ravintio-zero/docs/layout.md`).
- Backlog: entry 0000423 (priority high). The step row lists it.
- Pending migration 0009 left pending (see the build log).
- Baseline failures: a clean-clone run started in the background.
