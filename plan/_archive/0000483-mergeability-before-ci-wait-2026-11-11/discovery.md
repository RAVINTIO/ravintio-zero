---
title: "Discovery - 0000483-mergeability-before-ci-wait"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000483-mergeability-before-ci-wait

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000483-mergeability-before-ci-wait`, cut from `initiative/0000360-backlog-sweep` at `55a758ff`. The PR targets the initiative branch. |
| Skills inbox | `empty` |
| Track | `full` |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.91.0`. The chart bump for step 43 is `minor`.
- Prior features (`plan/_archive/`): 0000378 added `merge-queue.mjs`. 0000392 and 0000411 added the CI and head waits. 0000452 moved the archive after green CI. 0000472 is the latest archived run.
- Constraining ADRs (unless superseded): ADRs live in `docs/adr/`. The latest is 0310.
- Component and data-ownership map (`docs/`): one component, `ravintio-zero`. Its source is `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`.

## Problem findings

- Backlog entry 0000484 (evidence row 28 of the initiative 0000360 retrospective): PR #166 for step 36 conflicted with the initiative branch. GitHub runs no pull request workflows on a conflicting PR, so no check registered. Step 36 waited about 69 minutes.
- `merge-queue.mjs` `waitForChecks` polls `gh pr checks --json` until a check passes. It ends only on a failed check or after 1800000 ms. It never reads `mergeable` while it waits, so a conflict looks like a pending CI run.
- `roadmap-standards.md` I-D Advance item 4 tells the step to poll for checks for up to 2 minutes, then to run `gh pr checks --watch`. The first part stops the step if no check appears. Nothing tells the step to read `mergeable` before the poll, and the step does not merge the initiative branch when the PR conflicts.
- Wanted outcome: before a CI wait, the step and the queue read `mergeable`. A conflicting PR gets the initiative branch merged first. A wait that sees no checks after a set time stops with a named error.
- Backlog pickup: 0000484, named by the step 43 row. The entry widens no guard.
- Queue: `plan/.initiative-queue/` holds only `rebase-step-25`, which names another step. No item names step 43.
- Stale `plan/.feature-id` held `0000446-drain-ready-prs-after-a-stop`. Rewritten to this step's id.
- Migration 0009 is pending and needs a human answer, so this step leaves it.
