# Design - 0000442-ready-file-helper

## Feature
- Problem: a step writes the `ready` file by hand, and the driver stops on any value that is not a PR number.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000442-ready-file-helper
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a step session, I run one command that writes a checked ready file. Then the driver never meets an invalid file.
  - US-002: As the driver, I recover the PR number from the step branch when the ready file is bad. Then a slip costs no stop.
- Acceptance criteria confirmed: 6
  - AC-1: `initiative-ready.mjs --pr 42` writes `42` and a newline to `$RAVINTIO_INITIATIVE_CONTROL/ready` and prints `I-D Advance: Ready: PR #42`.
  - AC-2: The helper exits 1 and writes nothing in three cases. The value fails `^[1-9][0-9]{0,6}$`, the control variable is missing, or the control folder or ready file is a symlink.
  - AC-3: `--check` exits 0 for a valid file and exits 1 for a missing, empty, or invalid file.
  - AC-4: If `ready` is empty or invalid and exactly one open PR has head `feat/{feature-id}`, the driver rewrites `ready` with that number and carries on.
  - AC-5: If the lookup finds no PR, more than one PR, or fails, the driver stops with the existing `invalid ready file` line.
  - AC-6: The ship skill and `roadmap-standards.md` tell a step to use the helper.
- Constraints: the helper takes only digits as input. It builds no path from user text.
- Integrations: `gh pr list` in the driver.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the helper and the driver refuse a symlink at the control paths. The driver passes the branch name as one argument and never to a shell. The change widens no guard.
- Data privacy: no regulated data
- Observability: one stdout line per write or recovery
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the helper and the driver. The driver owns the control folder.
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: `initiative-ready.mjs`, driver recovery, ship skill and standard text, tests, an ADR, docs, a changelog entry, and the sync.
- Out: the merge queue, the `running` file, and the read of a valid `ready` file.
- Deferred: none

## Assumptions
- `gh` is on the PATH of the driver and holds a sign-in, as the merge queue already needs. Impact if wrong: recovery fails and the driver stops as it does today.
- The driver cuts the step branch as `feat/{feature-id}`. Impact if wrong: the lookup finds no PR and the driver stops as it does today.

## Risks
- Low likelihood, medium impact: recovery picks a wrong PR. The lookup accepts one open PR with that exact head and no other.
- Low likelihood, low impact: a step ignores the helper. The driver recovery covers that case.

## Dependencies
- Upstream: 0000379 (concurrent driver)
- Downstream: 0000444 (step 26 reads queue items)
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.80.1. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - ready file helper | ravintio-implement | Script and tests land together |
| REQ-002 - driver recovery | ravintio-implement | Driver change with a stub `gh` test |

## Repo Instructions
- custom-001 (git): fetch, pull, push, and `gh pr create` need no asking. Never commit to `main` or merge into `main`. You may squash into `initiative/*` after a clean P3 and green CI. Commit each artifact at once.
- custom-002 (orchestrator): split long, independent work across parallel subagents, or state why the work cannot split.
- custom-004 (ship): push and raise the PR without asking. Never merge into `main`. Report a failed push or `gh pr create` and stop.
- custom-006 (refresh-setup): run `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking. Any other command needs a human.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 10 Nov 2026 @ 04:31 p.m. GMT
