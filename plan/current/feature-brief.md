---
title: "Feature Brief - Driver prints a stop summary"
summary: "At each end of a run, the driver prints one summary block of merged steps, its own fixes, and the one action left for the human."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver prints a stop summary

**Feature ID:** 0000511-driver-stop-summary

## Business Goal

At each driver stop, the human reads many lines to learn what happened and whether they must act. The driver prints one state line per step, and the coordinator gathers the rest by hand. The driver now ends every run with a short summary block.

Source: backlog entry 0000512, pulled in by initiative 0000360 step 57. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Summary block at the end of a run | As the human, I want one block at each driver stop that lists the merged steps and the driver's own fixes, so that I need not read the whole output. | must-have | 1 |
| One action line | As the human, I want the block to end with the one action left for me, or "none", so that I know at once whether I must act. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver script `initiative-run.mjs` and `roadmap-standards.md` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Driver output on stdout | ravintio-zero (the driver) | The watcher and the coordinator read it |

### Integration Points

None change. The summary adds lines. It changes no existing line.

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ES modules) |
| Testing | Bash test files with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- A recorder in `out()` of `initiative-run.mjs` that notes merged steps, driver fixes, and a pending delivery.
- A summary block that the driver prints at every end of a run, stop or done.
- Three line kinds: `I-C Run: Summary: merged this run: {list or none}`, `I-C Run: Summary: driver fixes: {count}` with one `I-C Run: Summary: fix:` line for each fix, and `I-C Run: Summary: action for the human: {action or none}`.
- Tests, the driver header comment, `roadmap-standards.md`, and one ADR.

### Out of Scope
- Any change to an existing driver line.
- A summary file on disk, or any watcher change.
- A new stop condition.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The summary never changes an exit code and never throws | Tests for each exit path |

## Constraints and Assumptions

### Constraints
- The driver adds no dependency.
- The summary prints just before the final line, which stays last. It names no secret.
- Exit codes stay as they are (0, 1, and 75).

### Assumptions
- The existing lines name every merge and every driver fix. The recorder reads them and the driver needs no new state.

## Scenario Paths

**Happy path:** The driver merges steps 3 and 4, clears one ready file, and finishes. The block lists steps 3 and 4, one fix, and `action for the human: none`.

> The human reads three lines.

**First-run path:** The driver stops before it merges a step. The block says `merged this run: none` and `driver fixes: 0`.

> The block still prints.

**Error / sad path:** A step blocks. The block names the action: read the stop line and the step log, then start a new driver.

> The human sees the one action.

**Cross-session continuity:** The recorder holds state for one driver process only. A new driver starts with an empty record.

> Each run summarises itself.

## Acceptance Criteria

- [ ] A run that merges a step prints a `merged this run:` line that names it.
- [ ] A run that clears a ready file prints a `driver fixes:` count and a `fix:` line for it.
- [ ] A run that finishes with no stop prints `action for the human: none`.
- [ ] A run that stops on a `Blocked:` line prints an action line that points at the stop line and the step log.
- [ ] A planned restart stop exits 75 and a failure exits 1, as before.
