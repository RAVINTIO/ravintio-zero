---
title: "Discovery - 0000564-test-impact-hook-pins"
summary: "Raw discovery-pass findings for initiative step 20."
---
# Discovery - 0000564-test-impact-hook-pins

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000564-test-impact-hook-pins`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.121.0`
- Prior features (`plan/_archive/`): 0000563 is the latest. It added the `Output order` cause to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry: 0000523. Outcome: the plan scan has a `Hook change` cause covering the four grep targets the entry lists. A test checks for the cause.
- The four targets are the hook name and hook count words such as "five commands".
- The other two are the `expected-after.txt` fixture with `pack-facts`, and the margin or status text.
- The cause list lives in `references/test-impact-causes.md`, with 11 causes today. Suites that read it: 0000246, 0000355, 0000383, 0000562, 0000563.
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
- Queue: no item names step 20.
