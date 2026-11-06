---
title: "Design - 0000354-steps-run-to-the-end"
summary: "Confirmed design: driver resume, early-end rule, setup record stability, watcher wait, driver-args helper, and the step CI fixes field."
status: "confirmed"
---
# Design - 0000354-steps-run-to-the-end

## Feature
- Problem: A step session that ends its turn early stops the driver with no stated cause. Each setup stop costs a PR for one timestamp. The watcher reports false stale lines. Four driver suites repeat one argument string. The chart cannot say whether a step may fix its CI.
- Adoption mode: standard-iterative (signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000354-steps-run-to-the-end
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a coordinator, I want the driver to resume a step that exits 0 unmerged, up to two times.
  - US-002: As a step session, I read the rule that I never end my turn early.
  - US-003: As a coordinator, I want setup to leave the tracked record unchanged when only `writtenAt` would change.
  - US-004: As a maintainer, I want one helper for the driver arguments.
  - US-005: As a coordinator, I want the watcher to wait for the build log and name the running step.
  - US-006: As a chart author, I want a `**Step CI fixes:**` field.
- Acceptance criteria confirmed: 6
- Constraints: widens no guard. The driver passes every argument as an array. The initiative skill stays under 120 lines. Prose follows the writing standard.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope (no runtime target)
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The driver reads the session id from the child's stream events and checks it against `^[A-Za-z0-9_-]{8,128}$` before it passes it as one argument. It never prints the id or any log content. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults. A resume prints `I-C Run: Resuming: step {n} ended its turn unmerged, resume {k} of 2`. The final stop line keeps the `Log:` field.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM scripts, Bash, PowerShell, Markdown, Bash tests. Build target: ci-only.
- Components: `ravintio-zero` (scripts, setup, templates, skills, standards, tests)
- Data ownership: none
- Deployment: files in the pack. The driver, skill, and setup changes trigger `Restart:` and `Setup:` stops after the step.
- API versioning: not applicable

## Decisions
- Resume: the driver resumes only when `claude` exits 0, no block exists, and the position is unchanged. It resumes at most two times with `--resume {session}` and a continue prompt. The resume appends to the same step log. A third unmerged exit prints `I-C Run: Blocked: step {n} exited without merging after 2 resumes` and exits 1. A non-zero exit, a missing session id, or a block never resumes.
- Early-end rule: lives in the orchestrator skill. The first driver prompt stays `Run initiative step {n}`.
- Setup record: `setup.sh` and `setup.ps1` compare `tool` and `flags` with the existing record. If both match, they leave the file unchanged and print `= plan/state/{tool}.md (unchanged)`. The ignored marker keeps its timestamp.
- Helper: `ravintio-zero/tests/helpers/driver-args.sh` prints the fixed prefix `-p --output-format stream-json --verbose --permission-mode auto`. The three suites call it before the resume tests are added.
- Watcher: with no `plan/current/build-log.md`, it prints `I-C Run: waiting for the build log` once per absence and skips the stale check. The running step is the highest number among `step-{n}.log` names in `plan/.initiative-logs/`, falling back to the chart position.
- Chart field: `**Step CI fixes:** allowed | stop`, default `stop`. The ship skill reads it at P4: with `stop`, a CI failure on the step PR stops the step. With `allowed`, a fix inside the step's scope may be pushed.

## Scope
- In: see `plan/current/feature-brief.md`.
- Out: CodeQL and branch cleanup, any guard change, the first driver prompt.
- Deferred: none

## Assumptions
- Stream events carry `session_id` - impact if wrong: the driver cannot resume. It prints `Blocked:` and exits 1.
- `claude -p --resume {session} "{prompt}"` continues the session - impact if wrong: the resume exits 0 unmerged, and the cap ends it with `Blocked:`.

## Risks
- A resumed session repeats finished work. Likelihood low, impact low. The continue prompt tells it to read the build log first.
- The setup compare treats a hand-edited record as different. Likelihood low, impact low. Setup then rewrites it, as before.

## Dependencies
- Upstream: step 3 reshape and the chart `Steps` table
- Downstream: steps 5 to 8 run on the resumed driver
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Driver, watcher, setup, helper, and tests | ravintio-implement | TDD loop for scripts with a stub `claude` |
| Skill, standard, and template text | ravintio-implement | Docs land with tests that read the text |

## Repo Instructions
- custom-001: fetch, pull, push, and open PRs without asking. Work on a feat/ branch. Merging into main is human-only.
- custom-002: decompose long work into parallel subagents, or state why not.
- custom-004: ship pushes and raises the PR, never merges into main.
- custom-006: run `ravintio-zero/setup.sh claude-code --strict-orchestrator` without asking at a setup refresh.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 06 Nov 2026 @ 01:58 AM UTC
