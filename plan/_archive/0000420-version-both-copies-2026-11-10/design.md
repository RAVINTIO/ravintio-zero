# Design - 0000420-version-both-copies

## Feature
- Problem: the queue's version bump writes the installed `component.yml` but not the pack source copy, so CI's sync check fails after every bump.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000420-version-both-copies
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As an initiative coordinator, I want each version bump to keep both pack copies in step. Then CI passes after the bump.
- Acceptance criteria confirmed: 3
  - AC-1: A list line `? {path}` is optional. `readVersions` and `setVersions` use it when the file exists and skip it when it does not.
  - AC-2: A missing required entry still fails with `file not found`.
  - AC-3: After a queue run with both copies, both `component.yml` files hold the new version. The queue stages only files that exist.
- Constraints: required entries keep their behaviour.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no change. `resolveInRoot` still checks every path, optional or not.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts and bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the scripts
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep` before step 21 merges
- API versioning: not applicable

## Scope
- In: the `? ` prefix in `version-files.mjs` with a `presentPaths` export, `? src/ravintio-zero/component.yml` in the list, the queue staging present paths only, tests, and a changelog entry.
- Out: `sync-installed.mjs` and the pack layout.
- Deferred: none

## Assumptions
- Only the pack repo has `src/ravintio-zero/`. Impact if wrong: a consumer with that folder gets the version written there too, which is harmless.

## Risks
- Low likelihood, low impact: a typo in an optional path goes unseen, because the scripts skip a missing optional file. The test pins the shipped list.

## Dependencies
- Upstream: 0000378, 0000397
- Downstream: step 21 and every later queue run
- Approved dependencies: none

## Version
- No bump. This PR is not a chart step. The changelog entry records the fix.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - optional version files | ravintio-implement | Two small script changes and their tests |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 10 Nov 2026 @ 12:25 AM GMT. Coordinator CI fix under the human's standing approval to keep the queue moving, as for 0000405 and 0000411.
