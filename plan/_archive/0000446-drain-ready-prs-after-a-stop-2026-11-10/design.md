# Design - 0000446-drain-ready-prs-after-a-stop

## Feature
- Problem: After one merge queue failure, the driver holds back every other ready PR. Independent, green PRs wait for a human.
- Adoption mode: standard-iterative (only signal, assumed)
- Feature ID: 0000446-drain-ready-prs-after-a-stop
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)
- Track: light
- Version: step bump `minor` on 0.90.0. The merge queue sets 0.91.0.

## Product Layer
- User stories:
  - US-001: As the initiative coordinator, I want the driver to merge other ready PRs after a queue failure, so that independent steps do not wait.
  - US-002: As a reader of the roadmap standards, I want the drain rule written down, so that the docs match the driver.
- Acceptance criteria confirmed: 4
  - Steps 1 and 2 have ready PRs and the queue fails on step 1. The driver still queues step 2, and step 2 merges.
  - The driver exits 1 and prints a `queue stopped on step 1` line.
  - The driver runs the queue at most once per step.
  - `roadmap-standards.md` states the drain rule.
- Constraints: the driver never force-pushes and never merges into `main`.
- Integrations: the driver calls `merge-queue.mjs run`. The driver makes the same call as before.

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no guard changes. No guard widens.
- Data privacy: no regulated data
- Observability: each queue failure prints its own `I-D Advance: Blocked:` line
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the driver, the standards, and the tests
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: keep queueing ready PRs after a queue failure, one attempt per step. Print each failure. Mark the failed step `stopped` in the final report. Update the roadmap standards. Add a test. Add a changelog entry and the sync.
- Out: a manual drain command, new step starts after a stop, and queue worktree cleanup (backlog 0000477).
- Deferred: none.

## Assumptions
- A ready step never shares a lane with a failed step, and never lists it in `After`. The scheduler enforces both before the step starts. Impact if wrong: a drained PR could depend on an unmerged step.
- `prepareQueue` resets the queue worktree on each call. Impact if wrong: a failed run leaves files that break the next PR (backlog 0000477 tracks this).

## Risks
- A systemic failure, such as a CI outage, makes every ready PR fail in turn. Likelihood low, impact low. Each PR gets one attempt, so the run ends.
- The first stop line must still be the one the driver prints last. Likelihood medium, impact low. The test checks it.

## Dependencies
- Upstream: `merge-queue.mjs`, `initiative-chart.mjs`
- Downstream: the `ravintio-initiative` skill reads the driver stop lines
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - drain after failure | ravintio-implement | Code change driven by a failing test |
| REQ-002 - document the drain | ravintio-implement | Docs land with the code |

## Repo Instructions
- Git permissions: fetch, pull, push, and `gh pr create` need no ask. Never commit to `main`. Never merge into `main`.
- Commit locally after every meaningful artifact write.
- Prefer parallel subagents for independent units. Say why when a task cannot split.
- Ship: push and raise the PR, never merge. A step session leaves the PR to the merge queue.
- Setup refresh: only the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 11:25 PM local
