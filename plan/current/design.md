# Design - 0000578-plan-lists-pass-signals

## Feature
- Problem: The plan skill has no step that lists the ways a checked component produces its pass signal. A launcher failure with the pass exit code then passes the check. A missing guard once passed the hook check this way.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000578-plan-lists-pass-signals
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a plan author, I list every path to a pass signal, launcher failures included. Each path then has an acceptance criterion.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. Combined skill text stays at or under 1720 lines.
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
- In: a new `Pass signal paths` section in the plan skill, one new suite, docs and manifest updates.
- Out: a script that finds pass paths. A change to the Test impact scan or its cap.
- Deferred: none.

## Assumptions
- A section of about 8 lines fits under the 1720-line cap (1690 lines now). Impact if wrong: the step trims the text or moves it to a reference file.

## Risks
- A suite pins the plan skill text or the wording allowlist (likelihood: low, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: step 33 (merged) added the `Diff reader` cause and is the latest plan skill edit.
- Downstream: steps 35 and 36 convert suites to rule anchors and run after this step.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Pass signal paths step | ravintio-implement | One skill section and one suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 18 Nov 2026 @ 8:35 AM
