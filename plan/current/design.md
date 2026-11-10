# Design - 0000454-queue-failure-recovery

## Feature
- Problem: a failed queue run leaves a set-version commit on the step branch and leaves the queue worktree on a step branch. The next merge conflicts on the version rows, and a restart cannot check the branch out.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source in `src/`)
- Feature ID: 0000454-queue-failure-recovery
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As an initiative coordinator, I rerun a failed queue run, so that the version rows no longer conflict with the base branch.
  - US-002: As an initiative coordinator, I restart a step after a failed queue run, so that the step branch is free to check out.
  - US-003: As a maintainer, I run the restart path in a test, so that a regression in either fix fails CI.
- Acceptance criteria confirmed: 5
  - AC-1: After a failed run and a base version change, a rerun merges with no conflict and sets the new version.
  - AC-2: A rerun with an unchanged base version adds no commit.
  - AC-3: After a failed run, the queue worktree sits on a detached HEAD and another worktree can check out the step branch.
  - AC-4: After a successful run, the queue worktree sits on a detached HEAD.
  - AC-5: No run force-pushes. The remote step branch only gains commits.
- Constraints: ADR-0260 (merge, never rebase, never rewrite pushed history). The commit-msg hook limits.
- Integrations: `git` and `gh` through argument arrays.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no change. Every git and gh call keeps its argument array. The queue never passes a branch name from `gh` to git as an option.
- Data privacy: no regulated data
- Observability: the queue prints one line when it takes the base version rows back.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script and bash test suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns `merge-queue.mjs` and its tests
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/current/
- plan/changelog/
- plan/backlog/

## Scope
- In: `merge-queue.mjs` reverts an earlier set-version commit before it merges the base when the base version moved. It detaches the worktree after every run. A restart test. Docs, ADR, and changelog.
- Out: the tests that entry 0000400 covers (step 36). The driver's detach at the start of a queue run. Any history rewrite.
- Deferred: none

## Assumptions
- The queue worktree belongs to the queue. Impact if wrong: a detach drops the checkout of a branch that a person had open there.
- A set-version commit subject matches `chore({id7}): set version`. Impact if wrong: the queue finds no commit to revert and the old conflict returns.

## Risks
- Medium likelihood, low impact: a revert conflicts with a later change to the same lines. The queue stops with the exact git error and leaves the branch unchanged.
- Low likelihood, low impact: the detach fails on a dirty tree. The queue ignores that failure and the next run reports the dirty tree.

## Dependencies
- Upstream: 0000378, 0000411, 0000420
- Downstream: steps 32, 33, and 36, which edit the same file or its tests
- Approved dependencies: none

## Version
- Bump: minor, from the chart row. Plan with 0.78.0. The queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Revert stale set-version commit | ravintio-implement | One function in one script, with its test |
| Detach after every run | ravintio-implement | One `finally` block, with its test |
| Restart test | ravintio-implement | One bash suite using the existing fake gh shim |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: the units share one file, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 2:59 PM GMT. The chart approved this step. P0 self-confirms as I-C Run describes.
