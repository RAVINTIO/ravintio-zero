---
title: "Discovery - 0000563-test-impact-misses-output-readers"
summary: "Raw discovery-pass findings for initiative step 19."
---
# Discovery - 0000563-test-impact-misses-output-readers

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000563-test-impact-misses-output-readers`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.120.0`
- Prior features (`plan/_archive/`): 0000562 is the latest. It moved the scan causes to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry: 0000533. Outcome: the plan scan has an `Output order` cause that lists suites reading changed lines or the last line. A test checks for the cause.
- The cause list lives in `references/test-impact-causes.md`, with 10 causes today. Suites that read it: 0000246, 0000355, 0000383, 0000562.
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
