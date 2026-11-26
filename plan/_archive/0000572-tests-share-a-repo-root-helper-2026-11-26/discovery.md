---
title: "Discovery - 0000572-tests-share-a-repo-root-helper"
summary: "Raw discovery-pass findings for initiative step 28."
---
# Discovery - 0000572-tests-share-a-repo-root-helper

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000572-tests-share-a-repo-root-helper`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.146.0`
- Prior features (`plan/_archive/`): 0000577 is the latest archived plan change.
- Constraining ADRs: none that affect the test helpers.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entries 0000528 and 0000539 ask for one helper. Each suite works out the repo root from its own path today. A suite that passes from `src/ravintio-zero/tests/` fails from `ravintio-zero/tests/` when its depth is wrong.
- The postmortem `plan/postmortems/2026-11-13-installed-copy-repo-root.md` records the source defect. The suites `test-0000534-req-001-003-step-clock.sh` and `test-0000493-req-004-handoff-text.sh` hit it.
- Both trees are identical at the base, so the step edits `src/ravintio-zero/` and mirrors with `sync-installed.mjs`.
- Chart rows cover fast batches, in-step pin updates, pack edits in both trees, and known baseline failures.
- A docs unit logs `RED:` and `GREEN:` lines, per 0000410.
- Queue: no item names step 28.
