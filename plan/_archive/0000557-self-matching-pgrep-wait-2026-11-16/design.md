# Design - 0000557-self-matching-pgrep-wait

## Feature
- Problem: a `pgrep -f` wait loop matches its own shell, so a step session waits for the Bash time limit instead of the suite end.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `src/`)
- Feature ID: 0000557-self-matching-pgrep-wait
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I wait on an end marker or a process id, so that my wait ends with the suite
- Acceptance criteria confirmed: 3
- Constraints: edit both pack trees.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skill text, Bash tests, GitHub Actions, build target ci-only
- Components: ravintio-zero, the component pack that holds the skills, standards, and tests
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- plan/

## Scope
- In: the wait rule in two skill files, the test
- Out: hooks and scripts
- Deferred: nothing deferred

## Assumptions
- Skill and standard text is the only place that tells a session how to wait - impact if wrong: a script keeps the bad loop.

## Risks
- A new skill adds a `pgrep -f` wait later. Likelihood low, impact low. The test catches it.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - safe-suite-wait | ravintio-implement | skill text change with a test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 15 Nov 2026 @ 11:13 p.m. GMT
