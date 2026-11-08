# Design - 0000405-queue-merge-subject

## Feature
- Problem: the merge queue's base merge writes git's default subject, which can exceed 72 characters, so the `commit-msg` hook rejects it and the queue stops.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000405-queue-merge-subject
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator of an initiative, I want the queue to update a ready PR from the initiative branch without a hook stop, so that steps merge with no manual repair.
- Acceptance criteria confirmed: 3
  - AC-1: The queue's base merge commit has the subject `{7-digit step id}: Merge the initiative branch`.
  - AC-2: With a `commit-msg` hook that rejects subjects over 72 characters, and a step branch name long enough that git's default subject exceeds 72, the queue merges the base and continues.
  - AC-3: The existing 0000378 and 0000379 queue suites still pass.
- Constraints: never bypass the hook (`--no-verify`). Never weaken `commit-standards.md`.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no change. The `commit-msg` hook stays blocking.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script and a bash test suite
- Components: `ravintio-zero`, one line in `ravintio-zero/scripts/merge-queue.mjs` and one new test file
- Data ownership: `ravintio-zero` owns both files
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`. The coordinator takes the driver's `Restart:` stop after it merges.
- API versioning: not applicable

## Scope
- In: pass `-m "{id}: Merge the initiative branch"` to the base merge in `cmdRun`. The id is the first 7 digits of the step's `Feature id`. A test with a blocking `commit-msg` hook and a long branch name. A changelog entry.
- Out: the other driver gaps from the 2026-11-08 postmortem. They go to the next initiative.
- Deferred: none

## Assumptions
- The step's `Feature id` always starts with 7 digits. Impact if wrong: the subject has no id prefix. `checkTitle` already relies on the same form.

## Risks
- Low likelihood, low impact: a running driver keeps the old script. The coordinator restarts the driver after the merge.

## Dependencies
- Upstream: 0000378 merge-time versioning
- Downstream: every later merge in initiative 0000360
- Approved dependencies: none

## Version
- No bump. This PR is not a chart step, and the merge queue sets versions only for chart steps. The changelog entry records the fix.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - queue-merge-subject | ravintio-implement | One-line script fix with one test |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`. Squash-merging an own feature PR into `initiative/*` after a clean P3 and green CI is allowed.
- `custom-002-prefer-subagent-decomposition.md`: split long work into parallel subagents. This run is one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking. Never merge into `main`.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 08 Nov 2026 @ 02:49 PM GMT
