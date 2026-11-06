---
title: "Feature Brief - Steps run to the end"
summary: "Makes a step session resume when it ends early, stops setup churn, quiets the watcher before a build log exists, and lets the chart say whether a step fixes its own CI."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Steps run to the end

**Feature ID:** 0000354-steps-run-to-the-end

## Business Goal

A step session can end its turn after P2 with no pending task. The driver then stops with a block that names no cause. Each `Setup:` stop also costs a coordinator PR for one timestamp. The watcher reports a stale build log before a step writes one. This feature fixes those gaps so a step runs to the end without help.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Driver resumes an unmerged step | As a coordinator, I want the driver to resume a step that exits 0 unmerged, up to two times, so that an early end of turn needs no human. | must-have | 1 |
| Early-end rule | As a step session, I read that I never end my turn before `I-D Advance: Complete:` or a `Blocked:` line, so that I keep going. | must-have | 1 |
| Setup record stays put | As a coordinator, I want setup to leave `plan/state/{tool}.md` unchanged when only `writtenAt` would change, so that a `Setup:` stop needs no PR. | must-have | 1 |
| One driver-arguments helper | As a maintainer, I want the three driver suites to read the `claude` arguments from one helper, so that a flag change edits one file. | must-have | 1 |
| Watcher waits for the build log | As a coordinator, I want the watcher to print `waiting for the build log` and skip the stale check, and to name the running step, so that I see no false stale line. | must-have | 1 |
| Chart sets CI fixes | As a chart author, I want a `**Step CI fixes:**` field, so that a step knows whether it may fix its own CI failure. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, scripts, and tests of the pipeline |

### Data Ownership

None. The feature changes scripts, setup, templates, skills, standards, and tests. It touches no data store.

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| `initiative-run.mjs` | `claude` | child process, argument array | Adds `--resume {session}` and a continue prompt. It reads the session id from the stream events in the step log. |
| `initiative-watch.mjs` | `plan/.initiative-logs/` | file read | Takes the running step number from the newest step log name. |
| `setup.sh` and `setup.ps1` | `plan/state/{tool}.md` | file write | Writes the record only when `tool` or `flags` differ. |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM scripts), Bash, PowerShell, and Markdown |
| Runtime | Node |
| Testing | Bash test scripts in `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- Driver: after a step exits 0 with no block and an unchanged position, resume the session with `claude -p --resume {session}` up to two times. After the second resume, stop with `Blocked:` and exit 1. A resume writes to the same step log.
- A helper in `ravintio-zero/tests/helpers/` that prints the fixed driver arguments. The three driver suites read it first, then the resume tests use it.
- Orchestrator skill: a step session never ends its turn before `I-D Advance: Complete:` or a `Blocked:` line.
- Setup: `setup.sh` and `setup.ps1` leave `plan/state/{tool}.md` unchanged when only `writtenAt` would change. The ignored marker keeps its timestamp.
- Watcher: with no `plan/current/build-log.md`, print `waiting for the build log` once and skip the stale check. Name the running step from the newest step log.
- Chart template and roadmap standards: the `**Step CI fixes:**` field, `allowed` or `stop`, default `stop`. The ship skill reads it at P4.
- Tests for each rule, and docs.

### Out of Scope
- CodeQL and branch cleanup (step 5).
- Any change to `merge-guard` or another fail-closed hook.
- A change to the first driver prompt `Run initiative step {n}`.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Determinism | A fake `claude` gives the same sequence of lines on every run | Bash tests with a stub |

## Constraints and Assumptions

### Constraints
- The change widens no guard. The driver never passes the session id through a shell.
- The initiative skill stays under 120 lines. Prose follows the writing standard.
- `setup.ps1` changes with `setup.sh`.

### Assumptions
- The stream-json events carry a `session_id` field. If the driver cannot read one, it stops with `Blocked:` and does not resume.
- `claude -p --resume {session} "{prompt}"` continues the session.

## Scenario Paths

**Happy path:** A fake `claude` exits 0 without merging. The driver resumes it. The resumed session merges, and the driver advances.

> Drafted from the brief. Accepted by the initiative chart.

**First-run path:** A step that merges on its first run gets no resume. Setup run on a fresh repo writes the record. A watcher with no build log prints the waiting line.

> Drafted from the brief. Accepted by the initiative chart.

**Error / sad path:** A fake `claude` that exits 0 unmerged after the second resume makes the driver print `Blocked:` and exit 1. A missing session id stops with `Blocked:`. A non-zero exit never resumes.

> Drafted from the brief. Accepted by the initiative chart.

**Cross-session continuity:** The driver keeps the session id in memory only. The step log keeps every event, and the chart field lives in `initiative.md`. A new driver reads the position from the branch ref.

> Drafted from the brief. Accepted by the initiative chart.

## Acceptance Criteria

- [ ] With a fake `claude` that exits 0 unmerged, the driver resumes two times, then prints `Blocked:` on the third exit.
- [ ] Running setup twice leaves a clean `git status`.
- [ ] With no `plan/current/build-log.md`, the watcher prints no stale line.
- [ ] The three driver suites read their arguments from one helper.
- [ ] The chart template holds `**Step CI fixes:**`, and the standards and ship skill state how a step reads it.
- [ ] The orchestrator skill states the early-end rule.
