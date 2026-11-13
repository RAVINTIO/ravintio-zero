# Design - 0000503-planned-restart-exit-code

## Feature
- Problem: The driver exits 1 after a planned `Restart:` stop, so the host reports the background task as failed.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000503-planned-restart-exit-code
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the driver to exit 75 after a `Restart:` line, so that the host reports no failure.
  - US-002: As the coordinator, I want a real failure to keep exit 1, so that I still see a failed driver.
  - US-003: As the coordinator, I want the docs to name exit 75 as a planned stop, so that I treat it as one.
- Acceptance criteria confirmed: 5
- Constraints: the `Restart:` line text stays the same. The driver adds no dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The change sets an exit code and reads no new input. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: the exit code itself. The stop line keeps its text.
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, `roadmap-standards.md`, the initiative skill)
- Data ownership: `ravintio-zero` -> the driver exit code
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: a `planned` flag on the stop, exit 75 for a `Restart:` stop and exit 1 for every other stop. Tests, the driver header comment, `roadmap-standards.md`, the initiative skill, one ADR, and the installed copy refresh.
- Out: the `Setup:` stop without a restart, the handoff exit 0, the watcher, and any hook guard.
- Deferred: nothing deferred.

## Assumptions
- Code 75 means no other driver exit today - impact if wrong: the coordinator reads a second cause as a restart.
- A restart hit that shares a run with a failure reads as a failure - impact if wrong: the coordinator reads the stop line either way.

## Risks
- A failure exits 75 by mistake. Likelihood low, impact medium. Mitigation: the planned flag drops when any other stop line follows, and a test pins it.
- A test fixture still expects exit 1 for a restart line. Likelihood high, impact low. Mitigation: the step updates those fixtures.

## Dependencies
- Upstream: `Stop`, `main()`, `restartLine()`, and `setStop()` in `initiative-run.mjs`.
- Downstream: the initiative skill reads the code.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - exit 75 on a restart | ravintio-implement | Driver code change with a test |
| REQ-002 - exit 1 on a failure | ravintio-implement | Guard behaviour pinned by tests |
| REQ-003 - docs state the code | ravintio-implement | Standards text and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Draft accepted by the initiative, in place of a human: draft-accepted (initiative) // Date and Time confirmed: 12 Nov 2026 @ 01:31 AM local
