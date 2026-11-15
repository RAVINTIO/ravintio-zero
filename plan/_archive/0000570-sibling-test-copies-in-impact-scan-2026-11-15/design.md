# Design - 0000570-sibling-test-copies-in-impact-scan

## Feature
- Problem: The test impact scan never says to look in `tests/regression/`. A plan misses the copy of a test it edits, and the full suite finds it late.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000570-sibling-test-copies-in-impact-scan
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I list the regression copy of each test I name, so no pinned copy fails the full suite late.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Version 0.132.0 plus a minor bump. The scan holds 21 lines at most.
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
- Components: `ravintio-zero`, the component pack. It holds the plan skill and the tests.
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
- In: one sentence in the `## Test impact scan` section of the plan skill, one new suite, docs and manifest updates.
- Out: a script that finds sibling copies. A new cause line.
- Deferred: none.

## Assumptions
- The sentence fits the existing scan paragraph, so the scan stays at 21 lines. Impact if wrong: four suites need a higher cap.
- The plan skill has room under its byte and line caps. Impact if wrong: the step moves the sentence to the reference file.

## Risks
- A suite pins the plan skill size or the scan paragraph text (likelihood: medium, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 25 (merged) added the `Pack content` cause and set the cap at 21.
- Downstream: step 27 adds a cause to the same files.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Sibling-copy line | ravintio-implement | One sentence edit and one suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 11:14 p.m.
