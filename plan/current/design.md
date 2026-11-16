# Design - 0000558-plan-only-push-short-ci

## Feature
- Problem: A step pushes more than once to one pull request, and CI keeps each older run going beside the newest.
- Adoption mode: standard-iterative
- Feature ID: 0000558-plan-only-push-short-ci
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a step session, I want CI to cancel an older run on a newer push, so that only the newest head uses runners.
  - US-002: As a reviewer, I want a push that changes `plan/` to run every suite, so that every check still runs.
- Acceptance criteria confirmed: 4
- Constraints: Every push runs every suite. The chart row for step 14 cuts back entry 0000476, and it overrides the chart criterion "A plan-only push runs fewer suites".
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: No new permission. The `concurrency` block reads only `github.event_name`, `github.event.action`, `github.event.pull_request.number`, and `github.ref`. None holds user-controlled text.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: GitHub Actions YAML, Bash tests, Node scripts. CI: GitHub Actions. Build target: none.
- Components: `ravintio-zero`, the one component pack. It holds the workflow and the tests.
- Data ownership: `ravintio-zero` owns the workflow files.
- Deployment: none
- API versioning: not applicable

## Component Paths
- .github/workflows/
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: A `concurrency` block in `.github/workflows/ravintio.yml`. The group key holds the workflow name, the pull request number or the ref, and a `closed` flag. Only `pull_request` events cancel an older run. Tests for each.
- Out: The consumer copy `hooks/ravintio.yml`, which needs a consumer migration. Skipping a suite or a job. A path filter. A change to the ship skill.
- Deferred: Nothing deferred.

## Assumptions
- A new run cancels the older run of its group - impact if wrong: older runs keep running and the change has no effect.
- A cancelled run leaves no required check red - impact if wrong: the pull request shows a red check until the newer run ends.

## Risks
- A `closed` event cancels a validation run. Likelihood low, impact medium. The `closed` flag in the group key prevents it.
- A push to `main` cancels the release tag job of an earlier push. Likelihood medium, impact high. `cancel-in-progress` is false for a push event.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - cancel a superseded run | ravintio-implement | One workflow edit and one test |
| REQ-002 - keep every suite | ravintio-implement | A test that pins the job guards |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 16 Nov 2026 @ 04:04 AM UTC
