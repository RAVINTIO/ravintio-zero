# Design - 0000583-step-temp-cleanup-after-merge

## Feature
- Problem: Step sessions and suites leave temp files behind after a step merges, and they filled the disk on 2026-11-14.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000583-step-temp-cleanup-after-merge
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the driver, I remove a merged step's `/tmp/step{n}*` paths and extra worktrees and prune, so that a merged step leaves nothing behind.
  - US-002: As a suite, I remove my temp folders on every exit including a stop signal, so that no `ravintio_*` entry outlives the run.
- Acceptance criteria confirmed: 4
- Constraints: Node only, no new dependency. Cleanup never stops the run and never follows a symlink.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: removal uses `rmSync` on paths from `readdirSync` of the temp folder, matched by an anchored pattern. The removal never follows a symlink. Git runs with no shell.
- Data privacy: no regulated data
- Observability: a `Kept:` line for each path left behind
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash tests
- Components: `ravintio-zero` pack. `initiative-run.mjs` gains `cleanStepTemp`. Five suites and `helpers/git-isolation.sh` gain signal-safe traps.
- Data ownership: the driver owns `plan/.initiative-worktrees/` and the step's temp paths. Each suite owns the folders it makes.
- Deployment: pack files in `src/ravintio-zero/`, mirrored to `ravintio-zero/`
- API versioning: not applicable
- Method: after `removeControl` the driver calls `cleanStepTemp(root, n)`. The call lists `git worktree list --porcelain` and removes each worktree outside `plan/.initiative-worktrees/` whose basename matches `^step{n}(?![0-9])`. It then runs `git worktree prune`. Last, it removes each entry of `os.tmpdir()` and `/tmp` that matches the same pattern. The start sweep calls it for each merged step. Each suite adds `trap 'exit 143' TERM` and `trap 'exit 130' INT HUP` next to its `EXIT` trap so the cleanup runs.

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: `cleanStepTemp` in the driver, signal-safe traps in the four named suites, `0000029` and the git-isolation helper, tests, roadmap standards line
- Out: removing leaked entries from earlier runs, PowerShell suites
- Deferred: none

## Assumptions
- Step temp paths start `step{n}` in the temp folder - impact if wrong: the driver leaves a differently named path behind.

## Risks
- A suite pins the driver header or the standards text (likelihood medium, impact low). P1 runs the test impact scan.
- A pattern matching another step's path (likelihood low, impact high). The lookahead and a test cover it.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver cleanup | ravintio-implement | Node change with a test |
| REQ-002 - suite traps | ravintio-implement | bash change with a test |

## Repo Instructions
None

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 18 Nov 2026 @ 08:54 a.m. GMT
