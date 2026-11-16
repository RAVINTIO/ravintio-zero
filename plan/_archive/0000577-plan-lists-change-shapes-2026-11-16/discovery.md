---
title: "Discovery - 0000577-plan-lists-change-shapes"
summary: "Raw discovery-pass findings for initiative step 33."
---
# Discovery - 0000577-plan-lists-change-shapes

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000577-plan-lists-change-shapes`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.136.0`
- Prior features (`plan/_archive/`): 0000571 is the latest scan change. It extended the `Skill-text budget` cause.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000516. Outcome: a plan for a unit that reads a git diff lists a test world for each change shape. The entry names add, rename, and delete.
- The scan text holds 21 non-empty lines, counted from the `## Test impact scan` section of `SKILL.md` plus `references/test-impact-causes.md`. Seven suites cap it at 21. A new cause line breaks them. The step merges the `New test file` and `Non-suite file` causes into one line and adds the new cause on the freed line.
- The postmortem `plan/postmortems/2026-11-11-module-missed-a-renamed-entry.md` records the source defect.
- Chart rows for the step cover fast batches, in-step pin updates, pack edits in both trees, and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Queue: no item names step 33.
