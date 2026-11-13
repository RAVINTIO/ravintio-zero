# Design - 0000534-step-sessions-receive-clock

## Feature
- Problem: Nothing shows that a headless step session receives the clock hook output, so a wrong reply time has no evidence.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/` both exist)
- Feature ID: 0000534-step-sessions-receive-clock
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human, I want each step log to hold the hook output, so that I can see what the step session received.
  - US-002: As the human, I want a check that fails when a step log shows no clock, so that I find a silent step.
- Acceptance criteria confirmed: 5
- Constraints: the driver adds no dependency. The step log keeps mode 600.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The check reads a local log and writes nothing. It prints the log path and a count, never log text. Data classification: internal tooling, no personal data.
- Data privacy: no regulated data
- Observability: the step log gains hook events. That is the observability change.
- Cost boundary: not constrained

## Engineering Layer
- Stack: JavaScript (Node ES modules) / Bash tests / GitHub Actions CI / Build target: ci-only
- Components: `ravintio-zero` (the driver `initiative-run.mjs`, the new `step-clock-check.mjs`, `roadmap-standards.md`)
- Data ownership: `ravintio-zero` -> step logs
- Deployment: none. The pack source in `src/ravintio-zero/` syncs to `ravintio-zero/`.
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- plan/
- docs/
- src/ravintio-zero/
- ravintio-zero/

## Scope
- In: the driver flag, the check script, fixture logs, tests, header comment and `roadmap-standards.md` text, one ADR, the installed copy refresh.
- Out: a time zone setting, any hook or watcher change, a real `claude` session in CI.
- Deferred: nothing deferred.

## Assumptions
- The proof run represents a step session. Impact if wrong: the check on a real step log still fails and shows the gap.
- The machine zone explains the step 48 time. Impact if wrong: the check on the next step log shows whether the hook output arrived.

## Risks
- The new flag makes logs larger. Likelihood medium, impact low. Mitigation: each tool call adds two short events.
- The flag changes in a later CLI. Likelihood low, impact low. Mitigation: the driver test pins the flag, and the check fails when events are missing.

## Dependencies
- Upstream: `runStep` in `initiative-run.mjs`, `clock-context.mjs`.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver records hook events | ravintio-implement | Driver change with a test |
| REQ-002 - clock check script | ravintio-implement | New script pinned by fixture logs |
| REQ-003 - docs and ADR | ravintio-implement | Standards text and ADR land with the code |

## Repo Instructions
- custom-001-local-git-only (orchestrator, ship): fetch, pull, push, and PRs into `initiative/*` allowed. Merging into `main` is human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition (orchestrator): split independent units into subagents. This step is one small change with shared state, so it runs inline.
- custom-004-ship-push-and-raise-pr (ship): push and raise the PR. Never merge into `main`.
- custom-006-standing-setup-refresh-approval (refresh-setup): `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs without asking.

## Confirmation
Draft accepted by the initiative, in place of a human: draft-accepted (initiative) // Date and Time confirmed: 13 Nov 2026 @ 4:23 AM local
