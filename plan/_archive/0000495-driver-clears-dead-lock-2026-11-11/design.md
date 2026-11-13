# Design - 0000495-driver-clears-dead-lock

## Feature
- Problem: A driver start fails when `plan/.initiative-runner.lock` names a process that no longer runs.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000495-driver-clears-dead-lock
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I start a driver over a dead lock, so that I need not remove the file by hand.
  - US-002: As the coordinator, I want the driver to refuse when the lock names a running process, so that two drivers never run at once.
- Acceptance criteria confirmed: 3
- Constraints: the driver stays the one writer of the lock. A reused pid reads as alive.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The driver takes the lock only when it reads a plain pid and the process is gone. A symlink or unreadable lock refuses. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: one `out()` line when the driver takes a dead lock
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`)
- Data ownership: `ravintio-zero` -> `plan/.initiative-runner.lock`
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: dead-lock take-over in `main()` of `initiative-run.mjs`. One output line. Tests. Header comment and `roadmap-standards.md` text. One ADR. The installed copy refresh.
- Out: the `--handoff` path. `resume-detect.mjs`, the watcher, and the status script. Any hook guard.
- Deferred: nothing deferred.

## Assumptions
- A pid that `process.kill(pid, 0)` cannot signal with `ESRCH` is dead - impact if wrong: the driver takes a lock that a live driver holds. The `wx` write still lets one driver win.
- A reused pid reads as alive - impact if wrong: the driver refuses, and the coordinator removes the file as today.

## Risks
- Two drivers start together against one dead lock. Likelihood low, impact medium. Mitigation: the take-over removes the file, then writes with `wx`. The loser gets `EEXIST` and refuses.
- A lock still being written reads as empty. Likelihood low, impact low. Mitigation: unreadable or non-numeric content refuses.

## Dependencies
- Upstream: `alive(pid)` in `initiative-run.mjs` (0000493).
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - take a dead lock | ravintio-implement | Driver code change with a test |
| REQ-002 - refuse a live or unreadable lock | ravintio-implement | Guard behaviour pinned by tests |
| REQ-003 - document the rule | ravintio-implement | Header comment, standards text, and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 11 Nov 2026 @ 09:58 PM local
