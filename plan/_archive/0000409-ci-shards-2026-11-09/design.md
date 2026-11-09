# Design - 0000409-ci-shards

## Feature
- Problem: each CI test job runs its suites serially, and the `.ps1` suites run three times, so a step PR waits about 16 minutes for CI.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000409-ci-shards
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator of an initiative, I want CI on a step PR to finish in about 5 minutes, so that the queue merges steps sooner.
- Acceptance criteria confirmed: 3
  - AC-1: With `RAVINTIO_SHARD=i/n`, `run-tests.sh` and `run-tests.ps1` each run a disjoint subset of the suites, and the n subsets cover every suite. A malformed value exits 2.
  - AC-2: The workflow runs 4 bash shards and 4 Windows PowerShell 5.1 shards, behind summary jobs named `bash-suites` and `windows-powershell (powershell)` that pass only when every shard passes. No Windows pwsh job remains.
  - AC-3: CI on this PR finishes its slowest required check in 7 minutes or less.
- Constraints: no suite is skipped. No required check on `main` is renamed.
- Integrations: GitHub Actions, and the `Protect Main Branch` ruleset

## Architecture Layer
- Latency target: slowest required check in 7 minutes or less
- Availability target: not applicable
- Scalability target: the shard count is a matrix value, so it can grow
- Security: shard jobs keep `contents: read`, pinned checkout, and `persist-credentials: false`. Summary jobs check out nothing.
- Data privacy: no regulated data
- Observability: each shard prints its own summary
- Cost boundary: more parallel runner jobs, fewer Windows minutes overall

## Engineering Layer
- Stack: bash and PowerShell runners, GitHub Actions YAML
- Components: `ravintio-zero` runners and tests, plus the repo workflow `.github/workflows/ravintio.yml`
- Data ownership: `ravintio-zero` owns the runners
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`. After it merges, the coordinator removes `windows-powershell (pwsh)` from the ruleset.
- API versioning: not applicable

## Scope
- In: `RAVINTIO_SHARD` in both runners. Shard and summary jobs. Removing the Windows pwsh entry. Updating the three CI-shape tests and `tests/README.md`. ADR-0284 superseding ADR-0126. A changelog entry.
- Out: selecting suites by change impact. Speeding up single suites.
- Deferred: none

## Assumptions
- GitHub names a summary job's check after its `name:`. Impact if wrong: the ruleset waits on a missing check. The coordinator sees it on this PR before merging.

## Risks
- Medium likelihood, low impact: shards are uneven, because suites differ in length. Round-robin by sorted name spreads the long setup suites.
- Low likelihood, medium impact: a Windows pwsh-only fault goes unseen. pwsh still runs every `.ps1` suite on Linux, and Windows PowerShell 5.1 still runs on Windows.

## Dependencies
- Upstream: 0000036, 0000037, 0000151, 0000394 workflow lint
- Downstream: every later step PR in initiative 0000360
- Approved dependencies: none

## Version
- No bump. This PR is not a chart step. The changelog entry records the change.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - runner shards | ravintio-implement | Two runner changes and one test |
| REQ-002 - workflow shards | ravintio-implement | Workflow edit and test updates |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: this run is small and its units share the workflow file, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 09 Nov 2026 @ 01:14 PM GMT. The human chose "Shard and drop pwsh", "I edit the ruleset", and "CI hotfix first" in the coordinator session.
