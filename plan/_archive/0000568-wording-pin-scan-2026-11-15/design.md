# Design - 0000568-wording-pin-scan

## Feature
- Problem: The test impact scan has no cause for a prose rewrite. Tests that grep the old wording fail only at P3.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000568-wording-pin-scan
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I grep the tests for each changed sentence, so that I list every wording pin under `## Test impact`.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.128.0 plus a minor bump. The scan stays at 20 lines or fewer.
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
- In: one new cause in the reference file, one new suite, docs and manifest updates.
- Out: the optional slice-list script. Causes that steps 25 and 26 add. Any cap change.
- Deferred: the slice-list script.

## Assumptions
- The entry names `SKILL.md`, and the causes live in the reference file. Impact if wrong: none, because the test reads the scan text from both files.

## Risks
- A suite pins the cause list text (likelihood: low, impact: low). The step updates the pin and logs a `Rework:` line.
- The scan exceeds 20 lines (likelihood: low, impact: medium). The scan holds 19 lines and the cause adds one.

## Dependencies
- Upstream: step 23 (merged) edited the same file.
- Downstream: steps 25 and 26 add causes to the same file and meet the 20 line cap.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Prose rewrite cause | ravintio-implement | One cause edit and one suite |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 08:37 p.m.
