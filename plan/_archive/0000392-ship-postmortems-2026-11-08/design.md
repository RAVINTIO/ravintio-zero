---
title: "Design - 0000392-ship-postmortems"
summary: "Ship checks postmortems, the postmortem record holds all three CAPA types, and the merge queue waits for CI."
---
# Design - 0000392-ship-postmortems

## Feature
- Problem: No run writes postmortems, nothing checks for them, and the merge queue stops on a title mismatch and a refused merge.
- Adoption mode: standard-iterative
- Feature ID: 0000392-ship-postmortems
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a reviewer, I see ship fail when a stop or rework has no postmortem.
  - US-002: As a maintainer, I see a postmortem fail when a CAPA type is missing.
  - US-003: As a coordinator, I want the merge queue to wait for CI after its version push.
  - US-004: As a coordinator, I want P4 to raise a PR title that the queue accepts.
- Acceptance criteria confirmed: 6
- Constraints: Bash 3.2, Git Bash, argument arrays for `git` and `gh`
- Integrations: `gh` and `git`

## Architecture Layer
- Latency target: the queue polls every 10 seconds and stops after 30 minutes
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no data. The scripts read the build log and records as data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js, Bash, GitHub Actions, build target local
- Components: `ravintio-zero` - scripts, skills, standards, templates, tests
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: ship postmortem check, CAPA record check, template and skill changes, orchestrator reference rules, queue CI wait, PR title form, tests and docs
- Out: earlier initiatives' postmortems, a commit hook, retrospective changes
- Deferred: none

## Assumptions
- `gh pr checks --json name,bucket` is available - impact if wrong: the queue stops with the `gh` error.
- A postmortem line names a rework requirement by its `REQ-nnn` id - impact if wrong: the check reports an uncovered requirement.

## Risks
- The check blocks ship on legacy logs (low likelihood, low impact). Mitigation: it reads only the log being shipped.
- The poll starts before GitHub registers checks on the new head (medium, medium). Mitigation: an empty check list counts as pending until the timeout.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - ship postmortem check | ravintio-implement | Node script change with a suite |
| REQ-002 - CAPA record check | ravintio-implement | New Node script, template, skill, and suite |
| REQ-003 - queue waits for CI | ravintio-implement | Node script change with a stub `gh` suite |
| REQ-004 - PR title form | ravintio-implement | Skill text with a suite |

## Repo Instructions
Local git only, prefer subagent decomposition, push and raise the PR at ship, standing setup refresh approval (`ravintio-overrides/instructions/`).

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 08 Nov 2026 @ 01:30 AM UTC
