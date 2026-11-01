# Design - 0000315-isolated-test-state

## Feature
- Problem: Test results depend on session variables and repo state, and `test-0000164-req-007` checks a file that no longer holds the rules.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000315-isolated-test-state
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a developer in any session, I run the suite with `RAVINTIO_*` variables set, so that the result matches a clean shell.
  - US-002: As a developer, I want the runner to fail when a run changes the tree, so that a test never leaves repo state behind.
  - US-003: As a developer with a generated `CLAUDE.md`, I run the suite and `test-0000164-req-007` passes.
- Acceptance criteria confirmed: 3
- Constraints: code and docs land together. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The change touches tests only and widens no guard.
- Data privacy: no regulated data.
- Observability: the runner names each changed path.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash and PowerShell tests, Markdown, GitHub Actions CI, build target local
- Components: `ravintio-zero` - test runners and tests
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: environment clear in both runners, final tree check, temporary copies for tests that write repo state, req-007 fix, tests.
- Out: other flaky tests, hook and skill changes.
- Deferred: nothing.

## Assumptions
- Few suites need a `RAVINTIO_*` variable - impact if wrong: P2 sets the variable in each failing suite, as the chart decides.

## Risks
- The tree check fails on a file a suite legitimately leaves. Likelihood medium, impact low: P2 fixes the suite, and the check reads tracked and untracked files only.
- Clearing `RAVINTIO_*` removes a setting a user wants. Likelihood low, impact low: the runner keeps its four documented settings.

## Dependencies
- Upstream: steps 1 and 2 are merged.
- Downstream: later steps rely on a clean suite.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - runners clear RAVINTIO variables | ravintio-implement | Runner change with a test |
| REQ-002 - tests that write repo state use a copy | ravintio-implement | Per-suite change with a test |
| REQ-003 - final tree check | ravintio-implement | Runner change with a test |
| REQ-004 - req-007 checks the rule file | ravintio-implement | Test change |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 08:46 PM UTC
