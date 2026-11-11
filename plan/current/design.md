# Design - 0000450-coordinator-status-view

## Feature
- Problem: the initiative coordinator has no single view of the run. The watcher reads stale control files and prints no event for a ready file or a driver exit. The driver holds the queue failure reason until exit.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000450-coordinator-status-view
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I run one command that shows the queue, ready PRs, running steps, and live stops. I then report the true state.
  - US-002: As a coordinator, I see an event when a step is ready, the queue fails, or the driver exits. I then miss none.
  - US-003: As a coordinator, I see merged steps as merged, so that stale control files never show a step as ready.
  - US-004: As a human, I read decisions apart from routine fixes, so that I oversee the run.
- Acceptance criteria confirmed: 6
  - AC-1: The status script prints merged, ready, running, and pending steps with PR numbers, plus live stops.
  - AC-2: A stop for a step that the chart marks merged does not show.
  - AC-3: The watcher prints an event for a new `ready` file, a queue failure, and a driver exit.
  - AC-4: The watcher shows a chart-merged step as merged, never ready or running.
  - AC-5: The driver prints the queue failure reason when the queue fails.
  - AC-6: The initiative skill and `roadmap-standards.md` describe the status command and a report that lists decisions apart from routine fixes.
- Constraints: no new library or service. The change widens no guard.
- Integrations: none

## Architecture Layer
- Latency target: the status script exits in under 2 seconds on a 60-step chart
- Availability target: not applicable
- Scalability target: not applicable
- Security: the script writes no file, refuses symlinks at plan paths, treats file text as data, and passes git arguments as arrays
- Data privacy: no regulated data. The script prints no log content, only matched stop lines cut to 200 characters.
- Observability: the watcher and driver print the new events
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, Markdown standards, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the scripts, the skill, and the standards. The new script only reads initiative state.
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: `initiative-status.mjs`, watcher events, chart-based state, and the driver's queue failure line.
- Also in: the skill report format, standards text, tests, an ADR, docs, a changelog entry, and the sync.
- Out: changing which stops the driver takes, clearing printed stop lines, and any guard or hook change.
- Deferred: none

## Assumptions
- The chart `Status` column is the source of truth for merged steps. Impact if wrong: a merged step shows as live.
- A queue failure always reaches the driver output. Impact if wrong: the watcher misses the event and the status view still shows the step as ready.

## Risks
- Medium likelihood, low impact: a new driver output line breaks a test that matches driver output exactly. The step updates those tests.
- Low likelihood, medium impact: a changed driver file triggers the restart stop for later steps. The coordinator restarts the driver as the standards describe.

## Dependencies
- Upstream: 0000379 (concurrent driver), 0000446 (merge after a stop)
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.94.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - status script | ravintio-implement | One new script and one suite |
| REQ-002 - watcher events and chart state | ravintio-implement | One file and one suite |
| REQ-003 - driver queue failure line | ravintio-implement | One function in the driver and one suite |
| REQ-004 - skill report format and standards | ravintio-implement | Markdown and one doc suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: the requirements touch four files, so they may run as parallel subagents if the work grows.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T02:58:02Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
