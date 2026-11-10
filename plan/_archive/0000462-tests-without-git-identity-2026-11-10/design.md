# Design - 0000462-tests-without-git-identity

## Feature
- Problem: the local suite passes while two CI jobs fail. It runs with the developer's git identity. It never reads a boot file that starts with a BOM.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000462-tests-without-git-identity
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer of the pack, I see a suite fail locally when it commits with no identity. Then CI does not find it first.
  - US-002: As a maintainer of the pack, I see a suite fail locally when a script cannot read a boot file with a BOM. Then Windows PowerShell 5.1 files do not fail only in CI.
- Acceptance criteria confirmed: 4
  - AC-1: The runners hide the global and system git config from each suite, and git refuses to guess an identity.
  - AC-2: A suite that commits with no identity fails locally.
  - AC-3: A BOM fixture runs against each first-line reader, and each reader passes.
  - AC-4: With the PR #136 fixes reverted, the local suite fails on both defects.
- Constraints: no new library or service.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the change adds test isolation only. It widens no guard.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash and PowerShell runners, Node scripts, bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the runners, the helpers, and the suites
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: git isolation in `run-tests.sh` and `run-tests.ps1`, and fixes to suites that it exposes.
- In: a BOM fixture and suite, an ADR, docs, a changelog entry, and the sync.
- Out: other local and CI differences, and CI job changes.
- Deferred: none

## Assumptions
- Git honours `GIT_CONFIG_GLOBAL`, `GIT_CONFIG_NOSYSTEM`, and `user.useConfigOnly`. Impact if wrong: the isolation does not reproduce the CI failure.

## Risks
- Medium likelihood, low impact: the isolation exposes more suites than expected. Each gets an explicit identity in its own call.

## Dependencies
- Upstream: 0000382, 0000315
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.80.1. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - git identity isolation | ravintio-implement | Runner edits and suite fixes share one change |
| REQ-002 - BOM fixture | ravintio-implement | One fixture and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: split independent units into subagents.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T17:49:02Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
