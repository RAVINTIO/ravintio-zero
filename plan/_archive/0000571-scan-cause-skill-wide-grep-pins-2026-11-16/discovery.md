---
title: "Discovery - 0000571-scan-cause-skill-wide-grep-pins"
summary: "Raw discovery-pass findings for initiative step 27."
---
# Discovery - 0000571-scan-cause-skill-wide-grep-pins

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000571-scan-cause-skill-wide-grep-pins`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.134.0`
- Prior features (`plan/_archive/`): 0000570 is the latest scan change. It added the sibling-copy sentence to the scan in `skills/ravintio-plan/SKILL.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000404. Outcome: the plan lists the skill-wide pin in `## Test impact` before P2 edits a skill. A test checks that the plan skill names the cause.
- The scan text holds 21 non-empty lines, counted from the `## Test impact scan` section of `SKILL.md` plus `references/test-impact-causes.md`. Five suites cap it at 21. A new cause line breaks them, so the cause extends the existing `Skill-text budget` line and adds no line.
- `test-0000151-req-008-quiet-test-output.sh` is the entry's example. It greps every `SKILL.md` for `run-tests` and requires a quiet-mode command on that line.
- Chart rows for the step cover fast batches, in-step pin updates, pack edits in both trees, and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Queue: no item names step 27.
