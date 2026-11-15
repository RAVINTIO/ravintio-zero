# Design - 0000565-layout-move-test-impact

## Feature
- Problem: The Test impact scan has no cause for a folder move. Suites that find the repo root by depth, and state files keyed by path, fail only in the full suite.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000565-layout-move-test-impact
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I see a `Path move` cause, so that I grep the tests for depth-based root lookups and list path-keyed state files.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.122.0 plus a minor bump.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. Text and tests only. No data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the plan skill reference and the tests.
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
<!-- List every folder the plan writes. gate-write blocks writes outside this list. -->
- src/ravintio-zero/
- ravintio-zero/
- plan/
- docs/

## Scope
- In: a `Path move` cause in the reference file, one new suite, docs and manifest updates.
- Out: causes that steps 22 to 27 add. Hook and script changes. The optional pre-P2 pack check.
- Deferred: the pack check that runs the suite from the new folder.

## Assumptions
- The reference file already has a Pack Index row in the plan skill - impact if wrong: the step adds the row.

## Risks
- A suite pins the cause list text (likelihood: low, impact: low). The step updates the pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 20 (merged) added the `Hook change` cause to the same file.
- Downstream: steps 22 to 27 add causes to the same file.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - path move cause | ravintio-implement | One cause and one suite |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 04:06 PM
