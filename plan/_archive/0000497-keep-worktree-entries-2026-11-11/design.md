# Design - 0000497-keep-worktree-entries

## Feature
- Problem: The queue removes a step worktree with `--force`, so the step loses any untracked backlog entry it filed.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000497-keep-worktree-entries
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the driver to keep a worktree that holds untracked backlog entries, so that I lose no filed entry.
  - US-002: As the coordinator, I want a clean worktree removed as before, so that the queue keeps merging.
  - US-003: As a step session, I commit each backlog entry I file before the PR, so that the squash carries it.
- Acceptance criteria confirmed: 4
- Constraints: the driver stays the only remover of step worktrees. The driver adds no dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The check runs `git` with fixed arguments, never a shell. It deletes nothing. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: the queue stop line names each untracked file, up to the line limit
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, the ship skill, `roadmap-standards.md`)
- Data ownership: `ravintio-zero` -> `plan/.initiative-worktrees/step-{n}`
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: an untracked-entry check in `removeWorktree()` of `initiative-run.mjs`. A ship rule. Tests. Header comment and `roadmap-standards.md` text. One ADR. The installed copy refresh.
- Out: moving entries to the main tree's queue. Untracked files outside `plan/backlog/`. Step 52 (removing merged worktrees). Any hook guard.
- Deferred: nothing deferred.

## Assumptions
- `git ls-files --others --exclude-standard -- plan/backlog` run in the worktree lists the entries - impact if wrong: an entry could still be lost, and the test pins the listing.
- A refusal is acceptable to the coordinator - impact if wrong: a queue stop that the coordinator clears by committing the entry. The entry names refusal as an option.

## Risks
- A stop blocks the merge of an otherwise ready step. Likelihood low, impact low. Mitigation: the stop line names the files, and the coordinator commits them.
- Git fails to list the files. Likelihood low, impact medium. Mitigation: treat a failed listing as unsafe and stop.

## Dependencies
- Upstream: `removeWorktree()` and `queueTask()` in `initiative-run.mjs`.
- Downstream: step 52 (removes merged worktrees) reuses the check.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - refuse a worktree with untracked entries | ravintio-implement | Driver code change with a test |
| REQ-002 - remove a clean worktree, stop on a failed listing | ravintio-implement | Guard behaviour pinned by tests |
| REQ-003 - ship commits filed entries and docs | ravintio-implement | Skill rule, standards text, and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 11 Nov 2026 @ 10:53 PM local
