---
title: "Discovery - 0000405-queue-merge-subject"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000405-queue-merge-subject

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000405-queue-merge-subject`, cut from `initiative/0000360-backlog-sweep` at `8fca00f4`. Main is not the base: the PR targets the initiative branch. |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.62.0`
- Prior features (`plan/_archive/`): `0000378-merge-time-versioning` (2026-11-07) wrote `merge-queue.mjs`. `0000379-parallel-steps-on-worktrees` hands ready steps to it.
- Constraining ADRs (unless superseded): 0000378 ADR-001, the queue merges the base into the PR branch before CI.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns `ravintio-zero/scripts/merge-queue.mjs` and its tests.

## Problem findings

- `merge-queue.mjs:273` runs `git merge --no-edit origin/{base}`. Git writes the default subject `Merge remote-tracking branch 'origin/initiative/0000360-backlog-sweep' into feat/0000382-install-lifecycle`, which is 106 characters.
- The blocking `commit-msg` hook rejects subjects over 72 characters (`commit-standards.md` §1). The base merge fails, the queue aborts it, and the driver stops: `I-D Advance: Blocked: queue stopped on step 6` at about 13:28 UTC on 2026-11-08.
- Every ready PR behind the initiative head hits this, and each merge moves the head. Steps 6, 8, 12, 13, and 18 are ready.
- `test-0000378-req-002-003-merge-queue.sh` builds worlds with no `commit-msg` hook, so no test saw the long subject.
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, and `custom-006` in `ravintio-overrides/instructions/`.
- Backlog pickup: none. This hotfix takes no entries.
