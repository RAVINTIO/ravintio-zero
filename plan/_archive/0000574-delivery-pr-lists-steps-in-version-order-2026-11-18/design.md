# Design - 0000574-delivery-pr-lists-steps-in-version-order

## Feature
- Problem: I-E Delivery rule 6 names no order for the step table. No script prints it. A hand-built table in chart order showed versions out of order in PR #202.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000574-delivery-pr-lists-steps-in-version-order
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I read in rule 6 that the step table ascends by `Version`. The PR body then matches the history.
  - US-002: As a coordinator, I get the step table from `reshape-initiative.mjs` in replay order, so that I paste it without sorting by hand.
  - US-003: As a maintainer, I run a test on a chart with out-of-order versions. A regression in the printed order then fails the suite.
- Acceptance criteria confirmed: 3
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. The script prints chart text it already reads.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash tests, markdown. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds the script, the standard, and the tests.
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
- In: rule 6 text, a printed step table in `reshape-initiative.mjs`, one new suite, docs and manifest updates.
- Out: a change to the replay order. Writing the PR body.
- Deferred: none.

## Assumptions
- The script's version sort at line 149 stays the single source of order. Impact if wrong: the table and the replay disagree.

## Risks
- A suite pins the script output or the rule 6 text (likelihood: low, impact: low). The step updates each pin and logs a `Rework:` line.

## Dependencies
- Upstream: 0000378 made the replay order ascending `Version`.
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Rule 6 order | ravintio-implement | One sentence in the standard |
| REQ-002 - Printed table | ravintio-implement | One script change with a test |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 7:06 a.m.
