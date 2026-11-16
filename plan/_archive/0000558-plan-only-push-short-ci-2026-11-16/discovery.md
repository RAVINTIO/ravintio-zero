---
title: "Discovery - 0000558-plan-only-push-short-ci"
summary: "Raw discovery-pass findings for step 14 of initiative 0000544."
---
# Discovery - 0000558-plan-only-push-short-ci

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside `plan/_archive/` |
| Git pre-flight | Branch `feat/0000558-plan-only-push-short-ci`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.138.0`
- Prior features (`plan/_archive/`): 0000452-ci-wait-before-archive (2026-11-10) moved the archive after green CI. Its retrospective filed entry 0000476.
- Constraining ADRs: ADR-0298 (closing archive push), 0000409 ADR-0284 (shards), 0000394 (pinned actions).
- Component map: one component, `ravintio-zero`. The workflow lives in `.github/workflows/ravintio.yml`. The consumer copy lives in `src/ravintio-zero/hooks/ravintio.yml`.
- Backlog entry: `0000476-plan-only-push-short-ci`. The chart row cuts it back: every push runs every suite.
