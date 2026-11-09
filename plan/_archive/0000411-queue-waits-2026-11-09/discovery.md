---
title: "Discovery - 0000411-queue-waits"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000411-queue-waits

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/ holds prior runs` |
| Git pre-flight | `feat/0000411-queue-waits`, cut from `initiative/0000360-backlog-sweep` at `805b3cd4`. Main is not the base: the PR targets the initiative branch. |
| Skills inbox | `empty` |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.72.0`
- Prior features (`plan/_archive/`): `0000378-merge-time-versioning` wrote `merge-queue.mjs`. `0000405-queue-merge-subject` set its base-merge subject. `0000409-ci-shards` cut CI to about 5 minutes.
- Constraining ADRs (unless superseded): 0000378 ADR-001, the queue merges the base into the PR branch before CI.
- Component / data-ownership map (`docs/`): one component, `ravintio-zero`, owns `merge-queue.mjs` and its tests.

## Problem findings

- `cmdRun` step 5 pushes the version commit, then step 6 calls `gh pr merge` at once. GitHub answers `Pull Request is not mergeable`, because it has not checked the new head.
- Step 3 runs `gh pr checks --watch` right after the base-merge push. It can read the previous head's checks and return at once.
- The queue stopped this way on steps 8, 9, 10, 11, 13, and 16 of initiative 0000360 on 2026-11-09. Two runs in a row also gave `Base branch was modified`.
- `test-0000378-req-002-003-merge-queue.sh` and `test-0000405-req-001-short-base-merge-subject.sh` run the real queue against a fake `gh`. The 0000379 driver suites stub the queue.
- Repo instructions: `custom-001`, `custom-002`, `custom-004`, and `custom-006` in `ravintio-overrides/instructions/`.
- Backlog pickup: none. This hotfix takes no entries.

## Coaching record

On 2026-11-09 the coordinator proposed this fix, and the human answered "Yes go ahead".
