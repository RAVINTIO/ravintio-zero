---
title: "Discovery - 0000562-test-impact-scan-lists-the-mirrored-pack-tree"
summary: "Raw discovery-pass findings for initiative step 18."
---
# Discovery - 0000562-test-impact-scan-lists-the-mirrored-pack-tree

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archive in `plan/_archive/` beside source in `src/` |
| Git pre-flight | Branch `feat/0000562-test-impact-scan-lists-the-mirrored-pack-tree`, cut by the driver from the initiative branch. Initiative step, so no merge question. |
| Skills inbox | empty |
| Track | full |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.114.0`
- Prior features (`plan/_archive/`): 0000534 and 0000536 are the latest. 0000536 filed entry 0000540.
- Constraining ADRs: none that affect the plan skill text.
- Component and data-ownership map: one component, `ravintio-zero`. It owns no data. Source is `src/ravintio-zero/`. `ravintio-zero/` is the installed copy that `scripts/sync-installed.mjs` refreshes.

## Step inputs

- Backlog entry: 0000540. Outcome: a `Pack file edit` cause lists `test-0000493-req-004-handoff-text.sh`, P0 lists `src/ravintio-zero/` in `## Component Paths`, and a test checks both.
- Chart decision: move the Test impact scan causes to `skills/ravintio-plan/references/test-impact-causes.md` with a Pack Index row, before adding a cause.
- `ravintio-plan/SKILL.md` holds 203 lines and 13947 bytes.
- Tests that read the `## Test impact scan` section: 0000246-req-001, 0000355-req-003, 0000383-req-001-005. They must follow the move.
