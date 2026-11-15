---
title: "Discovery - 0000568-wording-pin-scan"
summary: "Raw discovery-pass findings for initiative step 24."
---
# Discovery - 0000568-wording-pin-scan

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000568-wording-pin-scan`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.128.0`
- Prior features (`plan/_archive/`): 0000573 is the latest. 0000567 added size cap and frozen-line wording to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000418. Outcome: the plan scan has a `Prose rewrite` cause that greps the tests for each changed sentence. A test checks that the plan skill names the cause.
- The entry names `SKILL.md`. The cause list lives in `references/test-impact-causes.md`, and the scan section in `SKILL.md` points there. The cause goes in the reference file, as steps 22 and 23 did.
- The scan holds 19 lines (the `SKILL.md` section plus the reference). `test-0000383-req-001-005-test-impact-causes.sh` caps it at 20. One new cause line fits and leaves no room for another. Steps 25 and 26 add causes too, so the cap needs a decision at their steps.
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
- Queue: no item names step 24.
