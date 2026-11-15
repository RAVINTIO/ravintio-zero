# Design - 0000567-test-impact-size-caps-and-frozen-lines

## Feature
- Problem: The `Size cap` cause finds the first cap and stops. The `Reference file edit` cause omits the base-line freeze and the boot template cap. Both gaps show up only in the full suite.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000567-test-impact-size-caps-and-frozen-lines
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I list every cap test with its value, so that I plan against the lowest cap.
  - US-002: As a plan author, I see the frozen-line check and the boot template cap named, so that I list them under `## Test impact`.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.124.0 plus a minor bump. The scan stays at 20 lines or fewer.
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
- In: edits to two causes in the reference file, one new suite, docs and manifest updates.
- Out: causes that steps 24 to 27 add. Hook and script changes. Any cap change.
- Deferred: nothing deferred.

## Assumptions
- Entry 0000526 names a 3800 byte boot cap. The suite holds 4000 now. Impact if wrong: none, because the cause names the suite.

## Risks
- A suite pins the cause list text (likelihood: low, impact: low). The step updates the pin and logs a `Rework:` line.
- The scan exceeds 20 lines (likelihood: low, impact: low). The edit adds words to existing lines and no new line.

## Dependencies
- Upstream: step 22 (merged) added the `History move` cause to the same file.
- Downstream: steps 24 to 27 add causes to the same file.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - size cap lists every cap | ravintio-implement | One cause edit and one suite |
| REQ-002 - frozen lines and boot cap | ravintio-implement | One cause edit and the same suite |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 06:30 p.m.
