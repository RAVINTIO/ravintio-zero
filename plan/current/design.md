# Design - 0000581-delivery-cleans-up-driver-state

## Feature
- Problem: I-E Delivery leaves the driver state of the delivered initiative in `plan/`, so the next initiative reads stale `running` files and step logs.
- Adoption mode: standard-iterative (signal: archive beside source)
- Feature ID: 0000581-delivery-cleans-up-driver-state
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`.
  - US-002: As the coordinator, I read the cleanup in I-E Delivery and the final report, so that I run it every time.
- Acceptance criteria confirmed: 5
- Constraints: Node only, no new dependency. A failed removal prints `Kept:` and never stops the run. The script deletes nothing outside `plan/` and the repo git folder.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the script moves and removes paths only under `plan/` and writes only under `.git/ravintio-archive/`. It refuses a symlink at any path it touches and never removes a path by name in a shared folder.
- Data privacy: no regulated data
- Observability: one `I-E Delivery:` line for each move, removal, and kept item
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node script, bash tests
- Components: `ravintio-zero` pack. New `scripts/initiative-cleanup.mjs`. Edits to `standards/roadmap-standards.md` and `skills/ravintio-initiative/SKILL.md`. New test suite.
- Data ownership: the driver owns `plan/.initiative-control/`, `plan/.initiative-logs/`, and `plan/.initiative-worktrees/`. The cleanup runs only after the driver has stopped.
- Deployment: pack files in `src/ravintio-zero/`, mirrored to `ravintio-zero/`
- API versioning: not applicable
- Method: `initiative-cleanup.mjs --id {id}-{slug} [--root <dir>]` exits 1 with `I-E Delivery: Blocked:` if `plan/.initiative-runner.lock` exists. Otherwise it moves `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`. A numeric suffix keeps an existing target. It removes each directory under `plan/.initiative-worktrees/` with `git worktree remove --force` and then prunes. It lists each item in `plan/.initiative-queue/` as a `Kept:` line. A missing folder prints `Kept:` and exits 0.

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the cleanup script, the I-E Delivery step and final-report item, the initiative skill lines, and tests.
- Out: running drivers, unmerged initiatives, deleting queue items
- Deferred: none

## Assumptions
- The coordinator runs the script from the main working tree - impact if wrong: the worktree removal misses the repo and prints `Kept:`.

## Risks
- A suite pins the I-E Delivery text or the skill size cap (likelihood medium, impact low). P1 runs the test impact scan.
- The script removes a worktree that holds unmerged work (likelihood low, impact medium). It runs only after the human merged the initiative PR, and it refuses while the lock exists.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - lock refusal | ravintio-implement | Node change with a test |
| REQ-002 - archive move | ravintio-implement | Node change with a test |
| REQ-003 - worktree removal | ravintio-implement | Node change with a test |
| REQ-004 - delivery text | ravintio-implement | Pack text with a rule test |
| REQ-005 - status after cleanup | ravintio-implement | Bash test over two scripts |

## Repo Instructions
- Git permissions: fetch, pull, push, and `gh pr create` need no ask. Work on a `feat/` branch. Commits to `main` and the final PR step into `main` are human-only. Report any failed remote git command.
- Commit granularly: commit after each artifact write.
- Orchestrator: split long work into parallel subagents unless the units share state, depend on each other, or are too small.
- Ship: push and raise the PR without asking, and stop on a failed push.
- Refresh setup: run only `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 26 Nov 2026 @ 10:03 a.m. GMT
