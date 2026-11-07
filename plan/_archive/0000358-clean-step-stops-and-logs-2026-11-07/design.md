# Design - 0000358-clean-step-stops-and-logs

## Feature
- Problem: Routine questions use `Blocked:`, build logs carry guessed times and open phases, and a failed test run shows only totals.
- Adoption mode: standard-iterative
- Feature ID: 0000358-clean-step-stops-and-logs
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a human on the loop, I see `Question:` on a routine question, so that `Blocked:` marks only an exception stop.
  - US-002: As a maintainer, I find every build log time comes from the clock and `build-log-check.mjs` fails a future time, so that a guessed time never reaches ship.
  - US-003: As a maintainer, I find `build-log-check.mjs` fails a closed phase block with no `Complete:` or `Skipped:` line, so that the watcher and resume read every phase end.
  - US-004: As a developer, I see each failed suite's file name under the totals, so that one run names every failure.
- Acceptance criteria confirmed: 3
- Constraints: chart Decisions rows for step 7 apply. Resume detection and governance counts keep reading `Blocked:`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change. The prefix hook only warns, so no fail-closed guard changes. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, Node (.mjs), PowerShell. Tests in Bash. CI GitHub Actions. Build target ci-only.
- Components: ravintio-zero pack (skills, hooks, scripts, templates, tests)
- Data ownership: none
- Deployment: setup copies pack files into consumer repos. A `Setup:` stop follows this step.
- API versioning: not applicable

## Scope
- In: `Question` status in six places. `Blocked:` limited to exception stops. Clock-time rule in phase skills. Two new `build-log-check.mjs` checks. Failed suite list in both test runners. Validate skill points at the list.
- Out: resume detection and governance counts. Fail-closed guards.
- Deferred: nothing deferred.

## Assumptions
- A committed build log lets git report the commit time of the line that adds a time - impact if wrong: the time check skips.

## Risks
- Time check false positive from a commit date that predates a rebase: likelihood low, impact medium. Mitigation: compare against the commit that adds the line, and skip when git is unreadable.
- Existing suites pin the old status set: likelihood high, impact low. Mitigation: update them in the same step.

## Dependencies
- Upstream: step 6 merged (0.54.0)
- Downstream: step 8
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - question-status | ravintio-implement | Edits to skills, templates, and a comment under tests |
| REQ-002 - clock-times | ravintio-implement | Skill text plus a script check |
| REQ-003 - closed-phases | ravintio-implement | Script check under fixtures |
| REQ-004 - failed-suite-list | ravintio-implement | Runner change in two shells |

## Repo Instructions
custom-001 local git only, custom-002 prefer subagent decomposition, custom-004 ship push and raise PR, custom-006 standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 07 Nov 2026 @ 05:02 UTC
