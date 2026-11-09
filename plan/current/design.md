# Design - 0000411-queue-waits

## Feature
- Problem: the merge queue merges before GitHub has checked the pushed head, so GitHub answers "not mergeable" and the queue stops.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000411-queue-waits
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator of an initiative, I want the queue to merge a green, clean step PR without a "not mergeable" stop, so that steps merge with no manual retry.
- Acceptance criteria confirmed: 3
  - AC-1: With a fake GitHub that reports a stale head and `UNKNOWN` mergeability for its first answers, the queue waits and merges.
  - AC-2: The queue never calls `gh pr merge` before GitHub reports the PR `MERGEABLE` with a clean merge state, and it retries a failed merge once on a transient error.
  - AC-3: The existing queue suites still pass.
- Constraints: never merge a PR whose checks failed. Never touch `merge-guard`.
- Integrations: the GitHub CLI

## Architecture Layer
- Latency target: the queue adds at most the time GitHub needs to check the head
- Availability target: not applicable
- Scalability target: not applicable
- Security: no change. The queue still merges only after CI passes.
- Data privacy: no regulated data
- Observability: a wait past its limit stops with `timed out waiting for PR #{n}`
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script and bash test suites
- Components: `ravintio-zero`, in `ravintio-zero/scripts/merge-queue.mjs` and its tests
- Data ownership: `ravintio-zero` owns both
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`. The coordinator restarts the driver after it merges.
- API versioning: not applicable

## Scope
- In: a `waitForState` helper that polls `gh pr view --json headRefOid,mergeable,mergeStateStatus`. The queue calls it after each push and before the merge. One merge retry. `MQ_POLL_MS` and `MQ_TIMEOUT_MS`, from 0000392, set the poll interval and limit, so tests run fast. Updated fake `gh` in the 0000378, 0000392, and 0000405 suites. A new suite.
- Out: regenerating shared files on a conflict.
- Deferred: none

## Assumptions
- `gh pr view` reports the same mergeability that `gh pr merge` uses. Impact if wrong: the retry covers the gap.

## Risks
- Low likelihood, medium impact: GitHub reports `BLOCKED` for a reason other than checks, such as a review rule. The queue waits to its limit, then stops with a named error.

## Dependencies
- Upstream: 0000378 merge-time versioning, 0000405, 0000409
- Downstream: every later merge in initiative 0000360
- Approved dependencies: none

## Version
- No bump. This PR is not a chart step. The changelog entry records the fix.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - queue waits for GitHub | ravintio-implement | One script change and its tests |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 09 Nov 2026 @ 03:50 PM GMT. The human answered "Yes go ahead" to the proposed fix in the coordinator session.
