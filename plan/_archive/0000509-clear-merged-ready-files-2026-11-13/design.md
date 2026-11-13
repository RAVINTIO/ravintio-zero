# Design - 0000509-clear-merged-ready-files

## Feature
- Problem: Merged steps leave `ready` files in `plan/.initiative-control/`, and the coordinator removes them by hand.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000509-clear-merged-ready-files
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I want the driver to remove a merged step's `ready` file, so that I do not clear it by hand.
  - US-002: As the coordinator, I want the driver to leave a live session alone, so that a running step loses no state.
- Acceptance criteria confirmed: 5
- Constraints: the driver stays the only remover of control files. The driver adds no dependency. A kept file never stops the run.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The pass resolves each path under the root and refuses a symlink, as `readControl()` does. It removes one fixed file name and never runs a shell. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: a cleared file prints one `I-C Run: Cleared:` line. A kept file prints one `I-C Run: Kept:` line with the reason
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, `roadmap-standards.md`)
- Data ownership: `ravintio-zero` -> `plan/.initiative-control/step-{n}`
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: a pass in `schedule()` of `initiative-run.mjs` that clears the `ready` file of each merged step. Tests. Header comment and `roadmap-standards.md` text. One ADR. The installed copy refresh.
- Out: unmerged steps. The `running` file, the `stopped` file, and the control folder. Worktrees and branches. Any hook guard.
- Deferred: nothing deferred.

## Assumptions
- A merged step needs no `ready` file, because the chart records the merge. Impact if wrong: the queue needs the file again, and a new driver reads the PR from the step branch.
- `runningPid()` and `alive()` report a live session. Impact if wrong: the pass keeps a file that could go, and the `Kept:` line says why.

## Risks
- The pass removes the `ready` file of a step that a person still runs. Likelihood low, impact low. Mitigation: only merged steps, and never while a `running` file names a live pid.
- The removal fails. Likelihood low, impact low. Mitigation: keep the file, print a `Kept:` line, and carry on.

## Dependencies
- Upstream: `readControl()`, `runningPid()`, `alive()`, and `schedule()` in `initiative-run.mjs`.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - clear the ready file of a merged step | ravintio-implement | Driver code change with a test |
| REQ-002 - keep a file when a session runs or removal fails | ravintio-implement | Keep rules pinned by tests |
| REQ-003 - docs and ADR | ravintio-implement | Standards text and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Draft accepted by the initiative, in place of a human: draft-accepted (initiative) // Date and Time confirmed: 13 Nov 2026 @ 1:37 AM local
