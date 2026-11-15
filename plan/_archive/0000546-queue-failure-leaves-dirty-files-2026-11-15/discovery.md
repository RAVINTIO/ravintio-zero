---
title: "Discovery - 0000546-queue-failure-leaves-dirty-files"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000546-queue-failure-leaves-dirty-files

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Source in `src/` beside an archive in `plan/_archive/` |
| Git pre-flight | Branch `feat/0000546-queue-failure-leaves-dirty-files`, cut by the driver from the initiative branch |
| Skills inbox | empty |
| Track | light |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.125.0`
- Prior features (`plan/_archive/`): earlier initiative steps, see the archive folder names.
- Component and data-ownership map: component `ravintio-zero` owns the pack. `src/ravintio-zero/` is the source and `ravintio-zero/` is the mirror.
- Repo instructions (`ravintio-overrides/instructions/`): four files. They cover local git only, subagent decomposition, ship push and PR, and the standing setup approval.
- Backlog entry: 0000477-queue-failure-leaves-dirty-files. A queue run that fails after it writes the version files and the chart, and before the commit lands, leaves a dirty queue worktree. The next run stops with `working tree is not clean`.
- Code read: `cmdRun` checks `git status --porcelain --untracked-files=no` and stops on a dirty tree. `mergeAndRelease` writes the version files and the chart at step 5, then runs `git add` and `git commit`, then pushes. A failed `commit` or `push` leaves the written files in the tree.
- Chart decision: reset only the version files that the failed run wrote, and only in the queue worktree.
- Existing tests: `test-0000454-req-001-queue-failure-recovery.sh` holds a fake `gh` and a world builder that the new test can copy.
