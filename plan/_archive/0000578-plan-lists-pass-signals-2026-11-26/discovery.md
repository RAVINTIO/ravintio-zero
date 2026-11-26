---
title: "Discovery - 0000578-plan-lists-pass-signals"
summary: "Raw discovery-pass findings for initiative step 34."
---
# Discovery - 0000578-plan-lists-pass-signals

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000578-plan-lists-pass-signals`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.144.0`
- Prior features (`plan/_archive/`): 0000577 added the `Diff reader` cause to the plan scan. 0000570 and 0000571 extended it earlier.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000529. Outcome: the plan skill has a step that lists every path producing a pass signal, including launcher failures. A test checks for the step.
- Source defect: `plan/postmortems/2026-11-12-missing-guard-passed-hook-check.md`. The hook check treated exit 2 as a pass, and `guard-run.mjs` also exits 2 for a guard it cannot run.
- The Test impact scan (SKILL.md section plus `references/test-impact-causes.md`) holds 21 lines and seven suites cap it there. The new step goes in its own section, outside the scan.
- Combined `SKILL.md` text is 1690 lines against a cap of 1720.
- Chart rows for the step cover fast batches, in-step pin updates, pack edits in both trees, and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Queue: no item names step 34.
