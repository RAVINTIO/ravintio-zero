# Design - 0000577-plan-lists-change-shapes

## Feature
- Problem: The test impact scan never says to name a test world for each change shape of a diff. A unit that reads a git diff then misses a rename until it runs on real data.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000577-plan-lists-change-shapes
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I name a test world for add, rename, and delete when a unit reads a git diff. The suite then fails before the unit runs on real data.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. The scan holds 21 lines at most.
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
- In: a new `Diff reader` cause in the plan reference file, a merge of two existing cause lines, one new suite, docs and manifest updates.
- Out: a script that finds diff readers. A higher scan cap.
- Deferred: none.

## Assumptions
- Merging `New test file` and `Non-suite file` frees one line and keeps both names. Impact if wrong: seven suites need a higher cap.

## Risks
- A suite pins the reference text or the wording allowlist (likelihood: low, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 27 (merged) extended the `Skill-text budget` cause and holds the scan at 21 lines.
- Downstream: step 34 edits the plan skill too and runs after this step in the same lane.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Diff reader cause | ravintio-implement | One cause edit and one suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 2:50 a.m.
