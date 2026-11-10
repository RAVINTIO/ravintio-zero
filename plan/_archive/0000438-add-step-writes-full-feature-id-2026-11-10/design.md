# Design - 0000438-add-step-writes-full-feature-id

## Feature
- Problem: `initiative-add-step.mjs` writes a bare seven-digit id in the `Feature id` cell, and the driver rejects it.
- Adoption mode: standard-iterative
- Feature ID: 0000438-add-step-writes-full-feature-id
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a coordinator, I add a step with the helper, so that the driver starts it with no manual fix
- Acceptance criteria confirmed: 4
- Constraints: edit `src/ravintio-zero/` then sync `ravintio-zero/`. No packages.
- Integrations: `initiative-run.mjs` reads the chart the helper writes.

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The helper reads and writes local files only. No sensitive data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM with no packages, Bash tests, GitHub Actions, Build target local
- Components: ravintio-zero, the pack that holds the initiative scripts
- Data ownership: ravintio-zero owns the chart format
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: write `{featureId}-{slug}` in the Steps row. Share one feature id pattern between helper and driver. Add a test that runs the helper's row through the driver pattern.
- Out: other chart fields, the backlog entry format.
- Deferred: nothing deferred.

## Assumptions
- The helper slug is the feature slug the driver pattern needs - impact if wrong: the row fails the pattern and the new test fails.

## Risks
- The driver exports no pattern today, so a shared definition touches `initiative-run.mjs`, which the restart stop watches. Likelihood medium, impact low: the driver restarts after the merge.

## Dependencies
- Upstream: none
- Downstream: steps 24 to 27 touch `initiative-run.mjs` in the driver lane and run after this step
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - full-feature-id | ravintio-implement | One script change with one test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 10 Nov 2026 @ 01:45 PM local
