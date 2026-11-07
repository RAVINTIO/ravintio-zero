# Design - 0000378-merge-time-versioning

## Feature
- Problem: A step bumps its version in P4, so two steps that run at once would compute the same version. The coordinator needs a serial merge queue that sets each version at merge, checks the PR title and every version file, and a reshape that follows merge order.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source)
- Feature ID: 0000378-merge-time-versioning
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I list the version files once, so that the bump and the check read the same list.
  - US-002: As a coordinator, I check a step PR title against the chart before the merge, so that the squash commit matches the history check.
  - US-003: As a coordinator, I merge one ready step PR at a time with its version set at merge, so that versions follow merge order.
  - US-004: As a coordinator, I reshape and check a branch whose steps merged out of chart order, so that delivery passes.
  - US-005: As a coordinator, I reshape a branch with admin commits that a later step builds on, so that delivery needs no human for a fold that clears the conflict.
- Acceptance criteria confirmed: 5
- Constraints: steps 1 and 2 keep today's P4 bump (chart decision). The squash title is `{7-digit feature-id}: {Title} (#{n})`. The orchestrator skill gains no text.
- Integrations: `gh` and `git` CLIs.

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no authentication of its own. Scripts call `git` and `gh` with argument arrays, never a shell string. The queue never force-pushes and never merges into `main`. Data classification: no regulated data.
- Data privacy: no regulated data
- Observability: standard defaults. Each script prints one line per action to stdout and errors to stderr.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts with no packages, Bash test suites, GitHub Actions CI, build target local
- Components:
  - `ravintio-zero`: pack of scripts, standards, skills, and tests.
- Data ownership: the chart `plan/current-initiative/initiative.md` and `ravintio-zero/version-files.txt` belong to `ravintio-zero`.
- Deployment: none. The pack installs through `setup.sh`.
- API versioning: not applicable
- Component paths: `ravintio-zero/`

## Scope
- In: `version-files.txt`, `version-files.mjs` (`check`, `set`), `merge-queue.mjs` (`title`, `versions`, `run`), merge-order sorting in `reshape-initiative.mjs` and `check-initiative-history.mjs`, admin-commit folds in the reshape, docs and manifest updates.
- Out: driver wiring, removal of the P4 bump, parallel steps, `Lane` and `After` columns, `merge-guard` changes.
- Deferred: removal of the P4 version edits waits for step 3 (driver in parallel mode).

## Assumptions
- Merged steps carry tags `v{Version}` - impact if wrong: the reshape cannot find a step commit and exits 1.
- `gh pr merge --squash --delete-branch` into `initiative/*` stays allowed by `merge-guard` - impact if wrong: the queue's merge step is blocked.

## Risks
- A fixture `gh` shim differs from the real `gh` - likelihood medium, impact medium. The shim covers only the calls the queue makes and the docs name them.
- A fold hides a real conflict - likelihood low, impact high. A fold stays only if the final tree equals the old head and the history check passes.

## Dependencies
- Upstream: none
- Downstream: step 3 wires the driver to the queue.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| all | ravintio-implement | Scripts with tests and docs through the TDD loop |

## Repo Instructions
- custom-001: Git permissions and commit cadence (fetch, pull, push, `gh pr create`, feat branch, commit granularly).
- custom-002: Prefer subagent decomposition for long tasks (orchestrator).
- custom-004: In ship, push and raise the PR, never merge into `main`.
- custom-006: Standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Decisions applied (initiative chart)
- Steps 1 and 2 use today's P4 bump. The queue sets versions from step 3.
- The PR title check runs in the merge queue before each merge.
- The queue checks every version file after it bumps and stops on a difference.
- The queue merges the initiative branch into the PR branch rather than rebasing it, because the step rules forbid force-pushes.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 07 Nov 2026 @ 04:30 PM UTC
