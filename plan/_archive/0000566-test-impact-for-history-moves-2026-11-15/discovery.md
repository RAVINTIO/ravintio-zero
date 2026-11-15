---
title: "Discovery - 0000566-test-impact-for-history-moves"
summary: "Raw discovery-pass findings for initiative step 22."
---
# Discovery - 0000566-test-impact-for-history-moves

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000566-test-impact-for-history-moves`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.123.0`
- Prior features (`plan/_archive/`): 0000565 is the latest. It added the `Path move` cause to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry: 0000405. Outcome: a plan that moves archived content into a live folder lists every suite with a `plan/_archive/` exclusion under `## Test impact`. A suite checks that the plan skill names the cause.
- The cause list lives in `references/test-impact-causes.md`, with 13 causes today.
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
- Queue: no item names step 22.
