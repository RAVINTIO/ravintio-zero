# Design - 0000583-step-temp-cleanup-after-merge

## Feature
- Problem: Step sessions and suites leave temp files behind after a step merges, and they filled the disk on 2026-11-14.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000583-step-temp-cleanup-after-merge
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the driver, I give each step session a private temp folder in its worktree. I remove the worktree after the merge, so a merged step leaves nothing behind.
  - US-002: As a suite, I remove my temp folders on every exit including a stop signal, so that no `ravintio_*` entry outlives the run.
- Acceptance criteria confirmed: 4 (revised 2026-11-26 after the scope change)
- Constraints: Node only, no new dependency. The driver deletes nothing outside the repo and a failed removal never stops the run.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the session runs in the Claude Code sandbox with writes limited to the worktree, its git folder, and its control folder. `TMPDIR` and `GIT_CEILING_DIRECTORIES` point at `{worktree}/.t`. Git runs with no shell. No pack script removes a path in a shared temp folder.
- Data privacy: no regulated data
- Observability: a `Kept:` line for each worktree left behind, and a `Blocked:` line when the temp path is too long
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash tests
- Components: `ravintio-zero` pack. `initiative-run.mjs` gains `privateTemp`, `sandboxSettings`, and `removeMergedWorktree`. `run-tests.sh` sets a private `TMPDIR`. Five suites and `helpers/git-isolation.sh` gain signal-safe traps.
- Data ownership: the driver owns `plan/.initiative-worktrees/` and each worktree's `.t` folder. Each suite owns the folders it makes.
- Deployment: pack files in `src/ravintio-zero/`, mirrored to `ravintio-zero/`
- API versioning: not applicable
- Method: `runStep` calls `privateTemp(cwd)`, which creates `{cwd}/.t` and stops when the path leaves under 20 characters below the 104-character socket limit. It passes `TMPDIR` and `GIT_CEILING_DIRECTORIES` in the child environment and `--settings` with the sandbox JSON. After a merge, `removeMergedWorktree` removes the worktree and runs `git worktree prune`. `run-tests.sh` makes a private folder for each run and removes it on exit. Each suite keeps its `EXIT` trap and exits on `TERM`, `INT`, and `HUP`.

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: private temp folder, sandbox, and worktree removal in the driver. A private `TMPDIR` in the runner. Signal-safe traps in the named suites and the git-isolation helper. Scratch rules, tests, and a roadmap standards line.
- Out: removing leaked entries from earlier runs, PowerShell suites
- Deferred: none

## Assumptions
- The sandbox settings keys `enabled` and `filesystem.allowWrite` work in the installed Claude Code - impact if wrong: the session runs without the sandbox.

## Risks
- A suite pins the driver header or the standards text (likelihood medium, impact low). P1 runs the test impact scan.
- A script deleting a path outside the repo (likelihood low, impact high). The driver has no name-based removal, and a test scans the pack scripts.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - private temp folder | ravintio-implement | Node change with a test |
| REQ-002 - suite traps | ravintio-implement | bash change with a test |
| REQ-003 - nothing deleted outside the repo | ravintio-implement | Node and bash test |
| REQ-004 - scratch under TMPDIR | ravintio-implement | Pack text with a rule test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 18 Nov 2026 @ 08:54 a.m. GMT. Revised after the human changed the scope on 26 Nov 2026.
