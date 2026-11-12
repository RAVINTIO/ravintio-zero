# Design - 0000501-remove-merged-worktrees

## Feature
- Problem: Nothing removes the worktree of a step that merged outside the current driver run, so old worktrees pile up and hold their branches.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000501-remove-merged-worktrees
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the driver to remove a safe merged worktree, so that old worktrees do not pile up.
  - US-002: As the coordinator, I want the driver to keep an unsafe worktree and name its files, so that I lose no work.
- Acceptance criteria confirmed: 5
- Constraints: the driver stays the only remover of step worktrees. The driver adds no dependency. A kept worktree never stops the run.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The sweep runs `git` with fixed arguments, never a shell. It resolves each path under the root and refuses a symlink, as `removeWorktree()` does. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: a kept worktree prints one `I-C Run: Kept:` line with the reason
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, `roadmap-standards.md`)
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
- In: a sweep of merged steps' worktrees in `schedule()` of `initiative-run.mjs`. Tests. Header comment and `roadmap-standards.md` text. One ADR. The installed copy refresh.
- Out: unmerged steps. Branch deletion. The queue worktree and control folders. Any hook guard.
- Deferred: nothing deferred.

## Assumptions
- A squash merge with `--delete-branch` removes `origin/feat/{id}`. Impact if wrong: the driver keeps a worktree that could go, and the `Kept:` line says why.
- `git status --porcelain` lists every uncommitted file, tracked or not - impact if wrong: a file could be lost, and the test pins the listing.

## Risks
- The sweep removes a worktree that a person still uses. Likelihood low, impact medium. Mitigation: only merged steps, and only a clean tree whose head reached origin.
- Git fails to inspect a worktree. Likelihood low, impact low. Mitigation: keep it and report.

## Dependencies
- Upstream: `keepUntrackedEntries()`, `removeWorktree()`, and `schedule()` in `initiative-run.mjs`.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - remove a safe merged worktree | ravintio-implement | Driver code change with a test |
| REQ-002 - keep and report an unsafe worktree | ravintio-implement | Guard behaviour pinned by tests |
| REQ-003 - docs and ADR | ravintio-implement | Standards text and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Draft accepted by the initiative, in place of a human: draft-accepted (initiative) // Date and Time confirmed: 11 Nov 2026 @ 11:55 PM local
