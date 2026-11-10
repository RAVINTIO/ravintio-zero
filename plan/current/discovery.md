---
title: "Discovery - 0000452-ci-wait-before-archive"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000452-ci-wait-before-archive

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and source sits in `src/` |
| Git pre-flight | `feat/0000452-ci-wait-before-archive`, initiative step worktree, cut by the driver |
| Skills inbox | empty |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.77.1`
- Prior features (`plan/_archive/`): 0000377 to 0000421, the earlier steps of initiative 0000360
- Constraining ADRs: `docs/adr/`
- Component / data-ownership map: one pack component, `ravintio-zero`, source in `src/ravintio-zero/`, installed copy in `ravintio-zero/`
- Pending migrations 0004, 0005, and 0008 do not apply. Migration 0009 needs a human answer and stays pending.
- Origin: backlog entry 0000412 and the postmortem `plan/postmortems/2026-11-08-archived-step-cannot-fix-ci.md`.
- Chart decision for step 30 (2026-11-10): ship waits for green CI and archives as its last push before `ready`. There is no reopen route, so `gate-write` stays as it is.
