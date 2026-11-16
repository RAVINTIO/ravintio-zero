# Design - 0000560-step-sessions-and-pending-migrations

## Feature
- Problem: A step session cannot answer a migrator prompt. 0000536 and 0000399 cover the step rule and the skip rules. No test pins the kept `not applicable` ledger rule when a Detect line is true.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000560-step-sessions-and-pending-migrations
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I run a test that plants each ledger row kind beside a Detect match. A change to the skip rules then fails the suite.
- Acceptance criteria confirmed: 5
- Constraints: edit `src/ravintio-zero/` and mirror to `ravintio-zero/`. `resume-detect.mjs` stays unchanged.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth, no new input. Tests only. No data.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and bash. Tests in bash. CI on GitHub Actions. Build target ci-only.
- Components: `ravintio-zero`, the component pack. It holds `resume-detect.mjs` and the tests.
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
- In: one new suite for ledger rows with a true Detect line, closing entry 0000403, docs and manifest updates.
- Out: any change to `resume-detect.mjs`, the resume reference, or `icrun-migration`.
- Deferred: none.

## Assumptions
- 0000536 and 0000399 cover the rest of entry 0000403. Impact if wrong: a step session still stops on a migration. A follow-up entry then adds the fix.

## Risks
- The new suite pins the `not applicable` rule (likelihood: low, impact: low). A later change to the rule updates the pin in the same step.

## Dependencies
- Upstream: 0000536 and 0000399 (merged).
- Downstream: none.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Ledger rows with a true Detect | ravintio-implement | One suite |

## Repo Instructions
- custom-001-local-git-only
- custom-002-prefer-subagent-decomposition
- custom-004-ship-push-and-raise-pr
- custom-006-standing-setup-refresh-approval

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 16 Nov 2026 @ 5:35 a.m.
