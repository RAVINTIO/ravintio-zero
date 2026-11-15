# Design - 0000545-clear-feature-id-at-ship

## Feature
- Problem: Ship leaves `plan/.feature-id` tracked, so each squash carries a stale id and the next base merge conflicts on it.
- Adoption mode: standard-iterative
- Feature ID: 0000545-clear-feature-id-at-ship
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I leave no `plan/.feature-id` in the step PR, so that the base merge never conflicts on it.
  - US-002: As the merge queue, I resolve a base-merge conflict on `plan/.feature-id`, so that a stale id never stops the queue.
  - US-003: As the initiative branch, I hold no `plan/.feature-id`, so that the next step starts clean.
- Acceptance criteria confirmed: 4
- Constraints: Pack edits go in `src/ravintio-zero/` and mirror to `ravintio-zero/`. No guard widens.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no change
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: shell and Node scripts, Markdown skills, bash tests, GitHub Actions CI
- Components: `src/ravintio-zero` (the pack source) and its mirror `ravintio-zero`
- Data ownership: the pack owns `plan/.feature-id` as a sentinel
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: ship Step 8 deletes `plan/.feature-id` for an initiative step. `shared-files.mjs` resolves it at a base merge. `git rm plan/.feature-id`. A test checks it.
- Out: other sentinels, resume detection logic.
- Deferred: none

## Assumptions
- A deleted `plan/.feature-id` does not break resume detection - impact if wrong: resume reports a missing id file on a fresh step.

## Risks
- A test pins Step 8 text. Likelihood medium, impact low. Update the pin and log `Rework:`.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - ship deletes feature id | ravintio-implement | Skill text and a test |
| REQ-002 - queue resolves feature id | ravintio-implement | Script change and a test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 14 Nov 2026 @ 03:10 PM
