---
title: "Discovery - 0000567-test-impact-size-caps-and-frozen-lines"
summary: "Raw discovery-pass findings for initiative step 23."
---
# Discovery - 0000567-test-impact-size-caps-and-frozen-lines

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000567-test-impact-size-caps-and-frozen-lines`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.124.0`
- Prior features (`plan/_archive/`): 0000566 is the latest. It added the `History move` cause to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000406. Outcome: the plan states the lowest cap for an edited skill. A test checks that the scan text asks for every cap, not the first match.
- Backlog entry 0000526. Outcome: the `Size cap` and `Reference file edit` causes name the frozen-line check and the boot template cap. A test in `test-0000383-req-001-005-test-impact-causes.sh` pins the wording.
- Finding: entry 0000526 says the boot template cap is 3800 bytes. `test-0000151-req-011-orchestrator-references-split.sh` now sets `CLAUDE_CAP=4000` (raised by 0000521). The cause text names the suite and says to read the cap from it, so the number cannot go stale.
- The cause list lives in `references/test-impact-causes.md` with 14 causes. The `Test impact scan` section of the plan skill plus the reference file must stay at 20 lines or fewer (`test-0000383` NFR-001).
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
- Queue: no item names step 23.
