# Design - 0000314-step-logs-stay-in-place

## Feature
- Problem: The git-ignored step log trips the phase guard in a step session, and a step session once moved driver files aside to avoid it.
- Adoption mode: standard-iterative (signal: source beside `plan/_archive/`)
- Feature ID: 0000314-step-logs-stay-in-place
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I run the suite with a populated step log, so that the phase guard suites pass without moving files.
  - US-002: As an initiative owner, I want the orchestrator and initiative skills to name the driver files a step must leave alone, so that the watcher, the driver, and the coordinator keep their evidence.
- Acceptance criteria confirmed: 4
- Constraints: code and docs land together. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The guard keeps scanning tracked and untracked source files. Only `plan/.initiative-logs` is skipped.
- Data privacy: no regulated data. Step logs stay private to the user.
- Observability: not applicable
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash tests, Markdown skills, GitHub Actions CI, build target local
- Components: `ravintio-zero` - phase guard test, orchestrator skill, initiative skill
- Data ownership: none
- Deployment: pack files copied by setup
- API versioning: not applicable

## Scope
- In: skip `plan/.initiative-logs` in the phase guard. Driver-file rule in the orchestrator and initiative skills. Tests.
- Out: tracked-only scanning. Test state isolation (step 3). A hook that blocks moves.
- Deferred: nothing.

## Assumptions
- Only the phase guard reads the step logs as a scan target - impact if wrong: another suite still fails and P1 widens the exclusion list.

## Risks
- The skill text grows past a size cap. Likelihood low, impact low: a size-cap test already runs.
- A scan of `plan` hides a real stale cite. Likelihood low, impact medium: skip only `plan/.initiative-logs`, and a planted-cite test proves it.

## Dependencies
- Upstream: step 1 (setup stop) is merged.
- Downstream: step 3 relies on a clean suite.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - guard skips step logs | ravintio-implement | Test change with a planted-cite check |
| REQ-002 - driver-file rule in skills | ravintio-implement | Text change with a test |
| REQ-003 - suite leaves step logs in place | ravintio-implement | Test of the full run |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval to run `ravintio-zero/setup.sh claude-code --strict-orchestrator` only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 31 Oct 2026 @ 08:03 PM UTC
