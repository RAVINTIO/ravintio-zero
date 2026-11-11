---
title: "Feature Brief - Reply times match the clock"
summary: "A PostToolUse hook gives agents the current time, the reply check tightens, and the watcher stamps its own clock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Reply times match the clock

**Feature ID:** 0000499-reply-times-match-clock

Source: backlog entry 0000500-reply-times-match-clock, filed after the step 27 driver stop.

## Business Goal

On 2026-11-11 step 27 printed reply times 10 to 13 minutes ahead of the clock and used an unknown status. Agents estimate times because a step is one long turn and the Stop hook runs only at its end. Every timestamp an agent writes must come from a clock read at that moment.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Clock hook | As an agent, I get the current local time after every tool call, so that I never estimate a time. | must-have | 1 |
| Clock rule text | As a maintainer, I find a rule in the skills and standards that every timestamp comes from a fresh clock read. | must-have | 1 |
| Tighter reply check | As a maintainer, I see a warning when a reply time is over 2 minutes off the clock or the status is unknown. | must-have | 1 |
| Stamped activity lines | As the human, I see the watcher's own time on each activity line, so that the feed stays right when an agent's time is wrong. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Hooks, setup, skills, standards, and the watcher |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `.claude/settings.json` hook entries | ravintio-zero | none |
| `plan/.prefix-misses.log` | ravintio-zero | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM), Markdown, Bash, PowerShell |
| Testing | Bash suites under `src/ravintio-zero/tests/` |
| CI | GitHub Actions |

## Scope Boundaries

### In Scope
- A `PostToolUse` hook that returns the local time, wired by `setup.sh` and `setup.ps1`.
- Clock rule text in the roadmap standards, the initiative skill, and the pipeline reference.
- A 2 minute margin and a status check in `check-reply-prefix.mjs`.
- A time stamp on each watcher activity line.
- Tests, an ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

### Out of Scope
- Any hook that blocks a turn or a tool call.
- Stamping lines other than activity lines.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Hook safety | The clock hook always exits 0 and prints valid JSON | Test asserts the exit code and the output |
| Hook cost | One local clock read, no file or network access | Review of the hook source |

## Constraints and Assumptions

### Constraints
- Hooks warn and never block a turn (0000200 ADR-002).
- The orchestrator `SKILL.md` stays under its 9000 byte cap.

### Assumptions
- Claude Code passes `hookSpecificOutput.additionalContext` from a `PostToolUse` hook to the model. Impact if wrong: the hook adds nothing and the rule text still applies.

## Scenario Paths

**Happy path:** After each tool call the agent holds a fresh `hh:mm` and writes it in its next reply line.

**First-run path:** A fresh install of setup wires the hook once, and a rerun adds no duplicate.

**Error / sad path:** A reply time over 2 minutes off the clock draws a warning and a log line. So does an unknown status such as `Running:`.

**Cross-session continuity:** The hook holds no state. A resumed session gets a fresh time after its first tool call.

## Acceptance Criteria

- [ ] The `PostToolUse` hook prints JSON whose `additionalContext` holds the current local `hh:mm`, and exits 0.
- [ ] `setup.sh` and `setup.ps1` wire the hook once and a rerun adds no duplicate.
- [ ] The roadmap standards, the initiative skill, and the pipeline reference require a fresh clock read for every timestamp.
- [ ] The reply hook warns when the prefix time is over 2 minutes off the clock. It also warns on a status outside the allowed list.
- [ ] Each watcher activity line starts with the watcher's own `hh:mm`.
