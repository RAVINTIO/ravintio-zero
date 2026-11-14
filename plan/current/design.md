# Design - 0000547-step-merge-regenerates-index

## Feature
- Problem: A step that merges the initiative branch by hand leaves `plan/backlog/index.md` stale, and CI fails on `backlog-index.mjs --check`.
- Adoption mode: standard-iterative
- Feature ID: 0000547-step-merge-regenerates-index
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a step session, I rebuild the backlog index after a manual base merge, so that CI does not fail on a stale index.
  - US-002: As the human, I want a test to check the rule, so that a later edit cannot drop it.
- Acceptance criteria confirmed: 3
- Constraints: no guard widens. Standards text and a test only.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change. No guard or hook changes.
- Data privacy: no regulated data
- Observability: none
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown standards, Bash tests, GitHub Actions CI, build target ci-only
- Components: `ravintio-zero`, the pack
- Data ownership: `plan/backlog/index.md` belongs to `ravintio-zero`
- Deployment: none
- API versioning: not applicable

## Component Paths
- ravintio-zero/
- src/ravintio-zero/
- docs/
- plan/

## Scope
- In: one rule in the I-D Advance section of the roadmap standards, a standards test, docs, an ADR.
- Out: `merge-queue.mjs`, `shared-files.mjs`, `backlog-index.mjs`, hooks, CI workflow.
- Deferred: nothing deferred.

## Assumptions
- A step session reads I-D Advance before it merges the base branch by hand - impact if wrong: the step still fails CI once.

## Risks
- A test pins the I-D Advance text - likelihood low, impact low. Update the pin in the same step.

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
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 14 Nov 2026 @ 03:11 PM GMT
