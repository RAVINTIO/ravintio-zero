---
title: "Discovery - 0000569-scan-new-pack-files-for-wording-allowlist"
summary: "Raw discovery-pass findings for initiative step 25."
---
# Discovery - 0000569-scan-new-pack-files-for-wording-allowlist

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000569-scan-new-pack-files-for-wording-allowlist`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.130.0`
- Prior features (`plan/_archive/`): 0000568 is the latest scan change. It added the `Prose rewrite` cause to `skills/ravintio-plan/references/test-impact-causes.md`.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry 0000415. Outcome: the execution plan lists the wording tests for a run that adds pack content. A test reads the scan and expects the new cause.
- The entry names `SKILL.md`. The cause list lives in `references/test-impact-causes.md`, so the cause goes there, as in steps 22 to 24.
- The scan holds 20 lines. Three suites cap it at 20: `test-0000383-req-001-005`, `test-0000567-req-001-002`, and `test-0000568-req-001`. One new cause line makes 21, so the step raises the cap to 21 in those suites. The chart's pin rule covers the edit.
- `test-0000042-req-010-pack-wording-allowlist.sh` bans the word "framework" in new pack content, outside its allowlist. The cause names that suite.
- Chart rows for the step: fast batches, test pins updated in-step, pack edits in both trees, known baseline failures.
- Queue: no item names step 25.
