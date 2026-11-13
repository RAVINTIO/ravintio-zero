---
title: "Feature Brief - Step sessions receive the clock"
summary: "The driver records hook output in each step log, and a check fails when a step session got no clock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Step sessions receive the clock

**Feature ID:** 0000534-step-sessions-receive-clock

## Business Goal

Step 51 added a hook that returns the local time after every tool call. Nothing showed that a headless step session receives it. The agent proved that it does. The step log still cannot show it, so the next wrong time has no evidence. The driver now records hook output, and a check fails when a step log holds no clock.

Source: backlog entry 0000535, pulled in by initiative 0000360 step 60. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Hook events in the step log | As the human, I want each step log to hold the hook output, so that I can see what the step session received. | must-have | 1 |
| Clock check | As the human, I want a check that fails when a step log shows no clock, so that I find a step that cannot report the time. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver `initiative-run.mjs`, a new check script, and `roadmap-standards.md` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Step logs in `plan/.initiative-logs/` | ravintio-zero (the driver) | The watcher and the new check read them |

### Integration Points

The driver adds one flag to the `claude -p` call. No existing driver line changes.

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ES modules) |
| Testing | Bash test files with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- The driver passes `--include-hook-events` to every step session, first run and resume.
- A script `step-clock-check.mjs {log}` that exits 1 when a step log holds tool calls and no `PostToolUse` hook output with `Local time: hh:mm`.
- Tests with fixture logs, the driver header comment, `roadmap-standards.md`, and one ADR that records the proof and the time zone finding.

### Out of Scope
- A time zone setting for step sessions.
- A change to the clock hook, the watcher, or any driver line.
- A test that starts a real `claude` session in CI.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The check reads a log and writes nothing | Test of the check |

## Constraints and Assumptions

### Constraints
- The driver adds no dependency.
- The step log keeps mode 600.

### Assumptions
- The `--include-hook-events` flag stays in the Claude Code CLI. A stub `claude` in tests accepts any flag.

## Scenario Paths

**Happy path:** A step session runs tools. Its log holds `PostToolUse` hook output with `Local time:`. The check exits 0.

> The human sees that the step received the clock.

**First-run path:** A log with no tool calls has nothing to check. The check exits 0 and says so.

> No false failure for an empty session.

**Error / sad path:** A step log holds tool calls and no clock output. The check exits 1 and names the log.

> The human finds the step that cannot report the time.

**Cross-session continuity:** A resumed step appends to the same log. The check reads the whole file.

> One verdict for the whole step.

## Acceptance Criteria

- [ ] The driver starts every step session with `--include-hook-events`.
- [ ] The check exits 0 for a log that holds a `PostToolUse` clock output.
- [ ] The check exits 1 for a log with tool calls and no clock output.
- [ ] The check exits 0 for a log with no tool calls.
- [ ] The ADR records the proof run and the time zone finding.
