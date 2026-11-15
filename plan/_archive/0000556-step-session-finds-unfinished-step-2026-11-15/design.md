# Design - 0000556-step-session-finds-unfinished-step

## Feature
- Problem: a step session that ends before P0 writes its build log leaves no signal, so a resume cannot tell where the step stands.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/`)
- Feature ID: 0000556-step-session-finds-unfinished-step
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I read a finding that names the missing P0, so that I start P0 without piecing the state together.
- Acceptance criteria confirmed: 4
- Constraints: the script prints no repo text and exits 0.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The script prints fixed lines and validated ids only. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js script, Bash tests, GitHub Actions, build target ci-only
- Components: ravintio-zero, the component pack that holds the script, reference, and tests
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: the new finding, the reference row, the test
- Out: driver changes
- Deferred: nothing deferred

## Assumptions
- The feature id is the branch name without `feat/` - impact if wrong: the finding misses a step and prints nothing.

## Risks
- A branch with a different name prints no finding. Likelihood low, impact low.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - unfinished-step-finding | ravintio-implement | script change with a test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 09:56 PM GMT
