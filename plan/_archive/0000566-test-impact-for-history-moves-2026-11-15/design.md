# Design - 0000566-test-impact-for-history-moves

## Feature
- Problem: The Test impact scan has no cause for a move of archived content into a live folder. Suites that exclude `plan/_archive/` as history flag the moved text only in the full suite.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000566-test-impact-for-history-moves
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I see a `History move` cause, so that I list every suite with a `plan/_archive/` exclusion under `## Test impact`.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.123.0 plus a minor bump.
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
- In: a `History move` cause in the reference file, one new suite, docs and manifest updates.
- Out: causes that steps 23 to 27 add. Hook and script changes.
- Deferred: nothing deferred.

## Assumptions
- The reference file already has a Pack Index row in the plan skill - impact if wrong: the step adds the row.

## Risks
- A suite pins the cause list text (likelihood: low, impact: low). The step updates the pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 21 (merged) added the `Path move` cause to the same file.
- Downstream: steps 23 to 27 add causes to the same file.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - history move cause | ravintio-implement | One cause and one suite |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 05:09 p.m.
