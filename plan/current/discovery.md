---
title: "Discovery - 0000393-session-integrity-and-guards"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000393-session-integrity-and-guards

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior features and `src/` exists |
| Git pre-flight | `feat/0000393-session-integrity-and-guards`, cut from `initiative/0000360-backlog-sweep` by the driver. No sync question in a step. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.64.0`
- Prior features (`plan/_archive/`): 0000388-replies-and-questions (2026-11-07) and 0000382-install-lifecycle (2026-11-08) are the latest
- Constraining ADRs: 0000164 ADR-002 (gate-write scopes to the project by real path), 0000317 ADR-001 (forced-add guard), 0000357 (wider forced-add guard)
- Component map: one component, `ravintio-zero`, at `ravintio-zero/`
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, `custom-006` in `ravintio-overrides/instructions/`
- Pending migrations 0004, 0005, 0008: `Applies when` is false here, so they stay pending
- Queue: `ci-gate-step-17` names step 17. It sets the CI-before-ready rule.
- Backlog entries from the step row: 0000271, 0000367, 0000272, 0000260
- Guard check: 0000271 and 0000367 make guards stricter. No entry widens a guard.
