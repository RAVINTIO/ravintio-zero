# Design - 0000483-mergeability-before-ci-wait

## Feature
- Problem: a conflicting PR gets no CI checks, so a CI wait never ends. Step 36 waited about 69 minutes. Backlog entry 0000484 records the case.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000483-mergeability-before-ci-wait
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I see the queue stop on a conflicting PR, so that a run never waits for absent checks.
  - US-002: As a step session, I merge the initiative branch into a conflicting PR before I wait for CI, so that checks register.
- Acceptance criteria confirmed: 4
  - AC-1: `merge-queue.mjs` stops with a named error when the PR is `CONFLICTING` and no checks have appeared.
  - AC-2: `merge-queue.mjs` stops with a named error when no checks appear after `MQ_NOCHECKS_MS`.
  - AC-3: A `MERGEABLE` PR with passing checks still passes.
  - AC-4: `roadmap-standards.md` and the ship skill tell the step to read `mergeable` before the CI poll.
- Constraints: no new library or service. The change widens no guard.
- Integrations: GitHub, through `gh pr view --json mergeable`

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no guard changes
- Data privacy: no regulated data
- Observability: the queue prints the named error
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards and skill text, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the script, the standards, and the skill
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the mergeability read and no-checks timeout in `waitForChecks`. Also the I-D Advance text, the ship skill text, a test, an ADR, docs, a changelog entry, and the sync.
- Out: conflicts on files other than shared files, driver and watcher changes, and any guard change.
- Deferred: none

## Assumptions
- GitHub reports `CONFLICTING` for a conflicting PR. Impact if wrong: the no-checks timeout still stops the wait.
- `UNKNOWN` is transient. Impact if wrong: the no-checks timeout stops the wait.

## Risks
- Low likelihood, medium impact: existing suites stub `gh pr view` without `mergeable` for the wait. The new read treats a missing value as not conflicting, so those suites keep passing.
- Low likelihood, low impact: the skill-text total passes its cap. The added line stays short.

## Dependencies
- Upstream: 0000392, 0000411
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.91.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - queue stops on a conflict or absent checks | ravintio-implement | One script change and one suite |
| REQ-002 - step reads mergeability before the CI poll | ravintio-implement | Standards and skill text, one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: two small units sharing one design, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T01:04:03Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
