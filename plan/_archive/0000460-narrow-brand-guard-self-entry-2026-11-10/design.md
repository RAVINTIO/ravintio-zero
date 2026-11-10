# Design - 0000460-narrow-brand-guard-self-entry

## Feature
- Problem: the brand guard allowlist holds a self-entry row that passes every line of the allowlist file, and no decision approved that widening.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000460-narrow-brand-guard-self-entry
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer of the pack, I want the guard to skip its allowlist files by exact path. Then no allowlist pattern can widen the guard.
- Acceptance criteria confirmed: 4
  - AC-1: The allowlist holds no row that matches the allowlist file.
  - AC-2: The guard skips `src/ravintio-zero/tests/brand-guard-allowlist.txt` and `ravintio-zero/tests/brand-guard-allowlist.txt`, and no other path.
  - AC-3: A file that names the retired word at a look-alike path fails the guard. Examples are `brand-guard-allowlist.txt.bak` and a copy in another folder.
  - AC-4: The CI test and `pre-push` use one skip rule.
- Constraints: the skip names exact paths and uses no pattern or allowlist row.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the change narrows a fail-closed guard. It widens nothing.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash scripts and bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the scripts and the allowlist
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Scope
- In: a shared exact-path function in `brand-guard.sh`. The script and the CI test scope both call it.
- In: removal of the self-entry row, tests, an ADR, docs, a changelog entry, and the sync.
- Out: other allowlist rows and the excluded prefixes.
- Deferred: none

## Assumptions
- Paths reach the guard relative to the repo root. Impact if wrong: the guard reports the allowlist file, which fails closed.

## Risks
- Low likelihood, medium impact: the CI test and the script drift apart. Both call one function, and a test pins that.

## Dependencies
- Upstream: 0000394, 0000397
- Downstream: none
- Approved dependencies: none

## Version
- Patch, from the chart row. Last known version 0.77.1. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - exact-path skip | ravintio-implement | One function, one allowlist edit, and their tests |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: one unit, so it runs inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-10T15:04:17Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
