# Design - 0000569-scan-new-pack-files-for-wording-allowlist

## Feature
- Problem: The test impact scan has no cause for new pack content. A banned word in a new file fails only at P3.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000569-scan-new-pack-files-for-wording-allowlist
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I list the wording tests when a run adds pack content, so no banned word reaches the suite.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.130.0 plus a minor bump. The scan holds 21 lines at most.
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
- In: one new cause in the reference file, one new suite, a cap of 21 in three suites, docs and manifest updates.
- Out: a script that scans new files. Causes that step 26 adds.
- Deferred: none.

## Assumptions
- The entry names `SKILL.md`, and the causes live in the reference file. Impact if wrong: none, because the test reads the scan text from both files.

## Risks
- A suite pins the cause list or its cap (likelihood: medium, impact: low). The step updates each pin and logs a `Rework:` line.
- The scan grows past 21 lines (likelihood: low, impact: low). The scan holds 20 lines and the cause adds one.

## Dependencies
- Upstream: step 24 (merged) added the `Prose rewrite` cause to the same file.
- Downstream: step 26 may add a cause to the same file and meet the new cap.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Pack content cause | ravintio-implement | One cause edit, one suite, and three cap edits |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 09:55 p.m.
