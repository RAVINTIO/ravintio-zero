---
title: "Discovery - 0000570-sibling-test-copies-in-impact-scan"
summary: "Raw discovery-pass findings for initiative step 26."
---
# Discovery - 0000570-sibling-test-copies-in-impact-scan

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000570-sibling-test-copies-in-impact-scan`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.132.0`
- Prior features (`plan/_archive/`): 0000569 is the latest scan change. It added the `Pack content` cause to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000407. Outcome: a plan lists the regression copy of any test it edits. A test checks that the plan skill text holds the sibling-copy line.
- The scan text holds 21 non-empty lines, counted from the `## Test impact scan` section of `SKILL.md` plus the reference file. Four suites cap it at 21: `test-0000383-req-001-005`, `test-0000567-req-001-002`, `test-0000568-req-001`, and `test-0000569-req-001`. A new line breaks the cap, so the sibling-copy sentence joins the existing scan paragraph in `SKILL.md` and adds no line.
- `ravintio-zero/tests/regression/` holds 21 suites with the same file names as suites in `ravintio-zero/tests/`. The entry's example is `test-0000034-req-003-atomic-settings-writes.sh`.
- Chart rows for the step cover fast batches, in-step pin updates, pack edits in both trees, and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Queue: no item names step 26.
