# Design - 0000318-titled-coordinator-prs

## Feature
- Problem: Coordinator work commits directly on the initiative branch, so the first-parent history holds untitled commits that skip CI.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000318-titled-coordinator-prs
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I want every coordinator change to reach the initiative branch as a titled PR, so that the history is one titled squash per change.
  - US-002: As a maintainer, I want the merge carve-out to name coordinator PRs and their bar, so that the agent may land them without widening a guard.
  - US-003: As a reviewer, I want ship to record the PR number before the squash, so that no commit follows the squash.
  - US-004: As a security reviewer, I want a test that pins `merge-guard`, so that the change widens no hook.
- Acceptance criteria confirmed: 4
- Constraints: code and docs land together. `merge-guard` behaviour stays as it is.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The change widens the written carve-out only and no hook. Data classification: no regulated data.
- Data privacy: no regulated data.
- Observability: not applicable
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skills and standards, Bash and PowerShell tests, Node.js hook (unchanged)
- Components: `ravintio-zero`
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: standards and skill text for coordinator PRs, ship PR-number ordering, `merge-guard` pinning tests, chart format update if needed, docs.
- Out: `merge-guard.mjs` changes, the history script (step 7), the initiative PR to `main`.
- Deferred: nothing.

## Assumptions
- `merge-guard` checks the PR base only, so a coordinator squash into `initiative/*` already passes - impact if wrong: the step stops and reports.

## Risks
- The wording widens the carve-out beyond the bar. Likelihood low, impact medium: the standards state the bar as three conditions and a test pins the hook.
- A coordinator PR races a running step. Likelihood medium, impact low: the PR is raised only while the driver is stopped.

## Dependencies
- Upstream: steps 1 to 5 are merged.
- Downstream: step 7 adds the history script that reads the titles this step requires.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - no direct commit rule | ravintio-implement | Standards text with a test |
| REQ-002 - coordinator PR bar and carve-out | ravintio-implement | Standards and skill text with a test |
| REQ-003 - ship records PR number before the squash | ravintio-implement | Skill text with a test |
| REQ-004 - `merge-guard` pinned | ravintio-implement | Test only |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Version
0.43.0 -> 0.44.0 (step 6 Bump: minor)

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 11:40 p.m. UTC
