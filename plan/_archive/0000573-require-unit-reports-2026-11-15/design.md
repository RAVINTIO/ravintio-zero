# Design - 0000573-require-unit-reports

## Feature
- Problem: A dispatched unit can return an empty report, and the dispatch standard does not say what a report holds.
- Adoption mode: standard-iterative
- Feature ID: 0000573-require-unit-reports
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As an orchestrator, I read a unit report with four fields, so that I log the unit without a rerun. The fields are a RED line, a GREEN line, a commit hash, and any deviation.
- Acceptance criteria confirmed: 2
- Constraints: Edit `src/ravintio-zero/` and mirror each change to `ravintio-zero/`.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: none, a prose standard. Data classification: public.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash tests, markdown standards, no new libraries. Build target: local.
- Components: `ravintio-zero`, the pack that holds the dispatch standard.
- Data ownership: `ravintio-zero` owns `agent-dispatch-standards.md`.
- Deployment: none
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/standards/
- ravintio-zero/standards/
- ravintio-zero/tests/
- src/ravintio-zero/docs/
- docs/
- plan/
- src/ravintio-zero/component.yml
- ravintio-zero/component.yml
- product.yml

## Scope
- In: a unit report rule in `agent-dispatch-standards.md`, a one-time resume for an empty report, and a test for the four fields.
- Out: a report-checking script and phase skill changes.
- Deferred: nothing deferred.

## Assumptions
- The tests directory lives at `ravintio-zero/tests/` only - impact if wrong: the test needs a second copy.

## Risks
- A test pins text the step edits. Likelihood low, impact low. The step updates the pin and logs a `Rework:` line.

## Dependencies
- Upstream: none
- Downstream: the orchestrator and phase skills read the standard.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - unit report rule | ravintio-implement | One standard edit with one test |

## Repo Instructions
- Git permissions: work on a `feat/` branch, push as you commit, never commit or merge to `main`.
- Commit granularly: commit after each artifact.
- Subagent decomposition: split independent units, or state why not.
- Ship: push and raise the PR, never merge into `main`. The merge queue merges a step PR.
- Setup refresh: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 14 Nov 2026 @ 03:24 PM GMT
