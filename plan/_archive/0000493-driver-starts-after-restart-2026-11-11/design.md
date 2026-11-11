# Design - 0000493-driver-starts-after-restart

## Feature
- Problem: after a merged step changes the driver, the concurrent driver starts no new step until every running step finishes.
- Adoption mode: standard-iterative (signal: `plan/_archive/` beside source in `src/`)
- Feature ID: 0000493-driver-starts-after-restart
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the coordinator, I want a new driver to start steps at once after a Restart. A ready step then never waits for unrelated steps.
  - US-002: As the coordinator, I want the new driver to adopt steps that the old driver still runs. No step then starts twice.
  - US-003: As the coordinator, I want a block in a handed-over step to stop the new driver, so that the stop rules still hold.
  - US-004: As the coordinator, I want the standards and the initiative skill to describe the handoff, so that I do not start a second driver.
- Acceptance criteria confirmed: 6
- Constraints: both pack trees stay identical. The driver has no dependencies beyond Node. The driver never edits the working tree.
- Integrations: none

## Architecture Layer
- Latency target: the successor starts a ready step within 10 seconds of the triggering merge.
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the driver gives the successor a fixed argument list. The pid and message files carry no shell input. The driver keeps its symlink refusals on the control folders.
- Data privacy: no regulated data
- Observability: the old driver prints one handoff line. The successor writes to the same output, so the coordinator's monitor sees every line.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ES modules with no dependencies, bash tests, GitHub Actions CI, build target local
- Components: `ravintio-zero` (existing). The change touches `scripts/initiative-run.mjs`, `scripts/initiative-watch.mjs` (reads the lock pid, only if needed), `standards/roadmap-standards.md`, `skills/ravintio-initiative/SKILL.md`, and the tests.
- Data ownership: the driver owns `plan/.initiative-runner.lock` and `plan/.initiative-control/`. No other component writes them.
- Deployment: none. The coordinator starts the driver as a background task.
- API versioning: not applicable
- Handoff protocol:
  1. A merge changes a watched file and no setup file. The old driver fast-forwards the root to the merged ref, as `approvedSetup` does. It then spawns `node initiative-run.mjs --root {root} --handoff` detached, with the old driver's own output and error handles.
  2. The old driver writes the successor pid into the lock and gives up its own claim, so it never releases the lock. It prints `I-D Advance: Restart: step {n} changed {files}. A new driver took over new starts.`
  3. The old driver keeps supervising its running sessions. It starts no step and runs no queue. A step that writes `ready` is the successor's to queue. A step that blocks or fails gets a `stopped` file in its control folder, which holds the stop line.
  4. The old driver exits 0 when its sessions end and the successor has exited or taken the lock. It never touches the lock after the handoff.
  5. The successor checks that the lock holds its pid. It reads the chart and the control folders. The successor adopts a step whose `running` file names a live pid other than its own. The step counts against the concurrency cap and starts no session. A step whose `running` pid is dead restarts its session in the existing worktree, as today.
  6. The successor polls each adopted step. A `ready` file moves the step to the queue. A `stopped` file stops new starts and prints the stop. A dead pid with neither file turns the step into a session restart.
  7. If the spawn fails, the root cannot fast-forward, or the chart has no `**Concurrency:**` field, the driver keeps the existing Restart stop.
- Decisions:
  - D-1: The old driver stays alive to supervise its sessions. Orphaning them would lose the resume rule and the block read. Rejected: re-exec in place, because Node has no exec and running sessions belong to the old process.
  - D-2: The successor shares the old driver's output handles, not pipes. The coordinator's monitor keeps reading one stream, and the old driver can exit first.
  - D-3: Only a `Restart:`-only hit hands off. A `Setup:` hit needs setup rerun first, so it keeps the stop.
  - D-4: The old driver exits 0 after a handoff. Step 53 owns exit codes for planned restarts and may change this.

## Component Paths
- ravintio-zero/scripts/
- ravintio-zero/standards/
- ravintio-zero/skills/ravintio-initiative/
- ravintio-zero/tests/
- src/ravintio-zero/scripts/
- src/ravintio-zero/standards/
- src/ravintio-zero/skills/ravintio-initiative/
- src/ravintio-zero/tests/
- src/ravintio-zero/docs/
- docs/
- plan/

## Scope
- In: the handoff on a `Restart:`-only hit, adoption of running steps, and the `stopped` file. Also the standards, header, skill, and test updates.
- Out: the serial driver path, `Setup:` hits, dead lock clearing, restart exit codes, and worktree removal.
- Deferred: none

## Assumptions
- The coordinator's main root sits on the initiative branch - impact if wrong: the fast-forward fails and the driver keeps the old stop.
- The `running` file holds the pid of the driver that supervises the session - impact if wrong: the successor starts a duplicate session.
- Inherited output handles stay valid after the old driver exits - impact if wrong: the successor loses its output.

## Risks
- A second driver starts a duplicate session. Likelihood low, impact high. A pid check and a test guard it.
- Two drivers queue the same PR. Likelihood low, impact high. Only the lock holder queues.
- The old driver dies while holding sessions. Likelihood medium, impact medium. The successor restarts them from the dead pid.

## Dependencies
- Upstream: the control folder format from step 3 (0000379) and the `readySteps` ranking from step 47.
- Downstream: steps 49 (dead lock), 50, 52, and 53 edit the same driver.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Plan-phase requirements | ravintio-plan | Produces requirements, ADR, and scope |
| Driver code and tests | ravintio-implement | TDD loop with tests and docs together |

## Repo Instructions
- custom-001 (git permissions): fetch, pull, push, and `gh pr create` need no ask. Work on a `feat/` branch. Never commit to `main` or merge into `main`. Commit after every artifact.
- custom-002 (subagent decomposition): split long tasks with independent units into parallel subagents, or state why the task cannot split.
- custom-004 (ship): push the branch and raise the PR without asking. Never merge into `main`.
- custom-006 (setup refresh): the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator` runs with no ask.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 11 Nov 2026 @ 08:16 PM local
