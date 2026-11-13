# Design - 0000511-driver-stop-summary

## Feature
- Problem: At each driver stop, the human reads many lines to learn what happened and whether they must act.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000511-driver-stop-summary
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human, I want one block at each driver stop. It lists the merged steps and the driver's own fixes, so I skip the full output.
  - US-002: As the human, I want the block to end with my one action, or "none", so I know at once whether to act.
- Acceptance criteria confirmed: 5
- Constraints: the driver adds no dependency. Exit codes stay as they are. The summary names no secret.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The summary repeats lines the driver already printed, so it adds no new data. It never runs a shell. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: the block is the observability change. It prints up to three line kinds under `I-C Run: Summary:`.
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, `roadmap-standards.md`)
- Data ownership: `ravintio-zero` -> driver stdout
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: a recorder in `out()`, a summary printer, and calls to it at each end of the run. Tests. Header comment and `roadmap-standards.md` text. One ADR. The installed copy refresh.
- Out: any change to an existing driver line, a summary file, a watcher change, a new stop condition.
- Deferred: nothing deferred.

## Assumptions
- The existing `Complete: step {n} merged`, `Cleared:`, `Ready: ... recovered`, `Setup: ... ran the approved`, and dead-lock `Starting:` lines name every merge and driver fix. Impact if wrong: the summary omits a fix, and the full output still holds it.
- A stop line decides the action. Impact if wrong: the generic action still points the human at the stop line.

## Risks
- The summary throws and hides the original stop. Likelihood low, impact medium. Mitigation: the printer sits in a `try` block and writes only strings.
- A new line breaks a reader of driver output. Likelihood low, impact low. Mitigation: the lines use a new `Summary:` status and print before the final line, so that line stays last.

## Dependencies
- Upstream: `out()`, `main()`, and the two final handlers in `initiative-run.mjs`.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - print the merged and fix lines | ravintio-implement | Driver code change with a test |
| REQ-002 - print the one action line | ravintio-implement | Action rules pinned by tests |
| REQ-003 - docs and ADR | ravintio-implement | Standards text and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Draft accepted by the initiative, in place of a human: draft-accepted (initiative) // Date and Time confirmed: 13 Nov 2026 @ 2:50 AM local
