# Design - 0000458-refuse-step-merge-outside-queue

## Feature
- Problem: a step session can squash-merge its own PR and bypass the merge queue. The PR then gets no version, no tag, and no `merged` chart row.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000458-refuse-step-merge-outside-queue
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I want `merge-guard` to refuse a PR merge from a step session. Then the merge queue is the only path that merges a step PR.
- Acceptance criteria confirmed: 4
  - AC-1: With `RAVINTIO_INITIATIVE_QUEUE=1`, a plain squash merge into `initiative/*` exits 2.
  - AC-2: Without the variable, the same command exits 0.
  - AC-3: `merge-queue.mjs run` still merges with the variable set in its parent process.
  - AC-4: The carve-out text names the queue as the only step merge path.
- Constraints: the guard narrows and widens nothing.
- Integrations: the driver sets the variable. The guard reads it.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the change narrows a fail-closed guard. It widens nothing.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js hook and Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the hook and the standards
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Scope
- In: the env check in `merge-guard.mjs`, tests, the carve-out text, an ADR, docs, a changelog entry, and the sync.
- Out: the merge queue and the driver.
- Deferred: none

## Assumptions
- Claude Code passes its environment to hook processes. Impact if wrong: the guard allows the merge as it does today.

## Risks
- Low likelihood, medium impact: the block stops a no-driver step that merges by hand. That path runs `merge-queue.mjs`, which a hook does not trip, and the variable is unset there.

## Dependencies
- Upstream: 0000454
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.80.1. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - refuse a step merge | ravintio-implement | One env check, its tests, and the carve-out text |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T16:33:00Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
