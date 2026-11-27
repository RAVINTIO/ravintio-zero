---
title: "Discovery - 0000552-duplicate-backlog-ids"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000552-duplicate-backlog-ids

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | source in `src/` beside `plan/_archive/` |
| Git pre-flight | branch `feat/0000552-duplicate-backlog-ids`, base `93b35538` (initiative branch tip) |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.138.0`
- Prior features: see `plan/_archive/`
- Constraining ADRs: none found for `backlog-index.mjs` beyond 0000321.
- Component map: one component, `ravintio-zero`, in `src/ravintio-zero/` and mirrored to `ravintio-zero/`.
- Backlog entry 0000542: `plan/backlog/0000542-duplicate-backlog-ids/entry.md`.
- Current state: `ls plan/backlog` shows no duplicate id. Only `0000476-plan-only-push-short-ci` still holds 0000476.
- Gap: `backlog-index.mjs` loads entries without comparing ids, so a duplicate passes `--check`.
