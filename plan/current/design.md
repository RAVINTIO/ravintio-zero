# Design - 0000536-pending-migrations-reach-the-human-early

## Feature
- Problem: A step session stopped in P0 on pending migration 0009 and the run waited about 4.5 hours for the human.
- Adoption mode: standard-iterative
- Feature ID: 0000536-pending-migrations-reach-the-human-early
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human, I answer every pending migration at I-A Chart, so that no step asks me later.
  - US-002: As the human, I want a step session to record a pending migration and carry on, so that the driver never waits for me.
  - US-003: As the human, I want the coordinator to raise each recorded migration when I am next available, so that none stays unseen.
- Acceptance criteria confirmed: 5
- Constraints: no guard widens. `ravintio-migrator` runs only on a human's answer or a chart row.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change. No guard or hook changes.
- Data privacy: no regulated data
- Observability: a `Migration pending:` build-log line
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skills and standards, Bash tests, GitHub Actions CI, build target ci-only
- Components: `ravintio-zero`, the pack
- Data ownership: `plan/state/migrations.md` belongs to `ravintio-zero`
- Deployment: none
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- docs/
- plan/

## Scope
- In: initiative skill, roadmap standards, orchestrator resume-detection check 1, tests, docs.
- Out: `resume-detect.mjs`, `ravintio-migrator` behaviour in a human session, hooks.
- Deferred: nothing deferred.

## Assumptions
- The human approved each migration that has a `Migration:` row, at chart time - impact if wrong: a migration runs unreviewed.

## Risks
- A step skips a migration that later steps need - likelihood low, impact medium. The coordinator raises each recorded line.
- Existing fixture-based tests compare skill text to a base fixture - likelihood high, impact low. Update the fixture rewrites.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| All | ravintio-implement | Text and test changes only |

## Repo Instructions
Read from `ravintio-overrides/instructions/`: local git only, prefer subagent decomposition, ship pushes and raises the PR, standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 13 Nov 2026 @ 04:21 AM GMT
