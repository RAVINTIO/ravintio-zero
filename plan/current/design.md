# Design - 0000448-driver-runs-approved-setup-command

## Feature
- Problem: four steps stopped the driver with `Setup:` for the same approved command, and each stop needed a coordinator restart. Backlog entry 0000427 records the case.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000448-driver-runs-approved-setup-command
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a coordinator, I let the driver rerun the approved setup command at a `Setup:` stop, so that the run continues with no restart.
- Acceptance criteria confirmed: 6
  - AC-1: A helper reads the `Confirmation:` row for setup in `## Decisions` and returns the command only if it matches the allowed form.
  - AC-2: The allowed form is the pack's `setup.sh` path followed by plain flag words. Anything else returns no command.
  - AC-3: At a `Setup:` stop the driver runs the command with no shell and carries on, in both the serial and the concurrent path.
  - AC-4: A missing row, a different command, or a non-zero exit stops the driver as before.
  - AC-5: A `Restart:` hit still stops the driver after the command has run.
  - AC-6: The roadmap standards and the initiative skill describe the behaviour.
- Constraints: no new library or service. The change widens no guard. The driver runs only the exact command in the row.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the command comes from the chart, which the human approved. The helper accepts one path and flag words only, and the driver runs it with an argument array and no shell.
- Data privacy: no regulated data
- Observability: the driver prints one line for each run of the command
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js scripts, Markdown standards and skill text, Bash suites
- Components: `ravintio-zero`, source in `src/ravintio-zero/`, synced to `ravintio-zero/` with `sync-installed.mjs`
- Data ownership: `ravintio-zero` owns the driver, the helper, the standards, and the skill
- Deployment: lands as a PR into `initiative/0000360-backlog-sweep`
- API versioning: not applicable

## Component Paths
- src/ravintio-zero/
- ravintio-zero/
- docs/
- plan/

## Scope
- In: the helper, the driver change, the standards and skill text, tests, an ADR, docs, a changelog entry, and the sync.
- Out: a change to `setup.sh` or any hook, and any guard widening.
- Deferred: the hook check after setup stays with the coordinator.

## Assumptions
- The main working tree sits on the initiative branch when the coordinator runs the driver. Impact if wrong: the driver cannot bring the installed files up to date and stops with the `Setup:` line as before.
- The `Confirmation:` row names the command in code font in its answer column. Impact if wrong: the helper finds no command and the driver stops.

## Risks
- Medium likelihood, medium impact: setup rewrites hook wiring. The helper limits the command to the pack `setup.sh` with flag words, and the driver stops on any other form.
- Low likelihood, medium impact: setup runs from stale files. The driver runs it only when the main tree matches the merged initiative ref.

## Dependencies
- Upstream: 0000373, 0000446
- Downstream: none
- Approved dependencies: none

## Version
- Minor, from the chart row. Last known version 0.91.0. The merge queue sets the released version at merge.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - setup command helper | ravintio-implement | One new script and one suite |
| REQ-002 - driver runs the command | ravintio-implement | One driver change and one suite |
| REQ-003 - standards and skill text | ravintio-implement | Two Markdown files and one suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and raise PRs without asking. Human-only: committing to `main` and merging into `main`.
- `custom-002-prefer-subagent-decomposition.md`: three small units that share one driver file, so they run inline.
- `custom-004-ship-push-and-raise-pr.md`: in ship, push and raise the PR without asking.
- `custom-006-standing-setup-refresh-approval.md`: the setup refresh runs with the approved command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 2026-11-11T01:06:00Z. Scope Lock Challenge lines each end with [source: draft-accepted (initiative)].
