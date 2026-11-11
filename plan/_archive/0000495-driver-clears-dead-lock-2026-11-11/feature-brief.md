---
title: "Feature Brief - Driver clears a dead lock"
summary: "The driver reports a lock whose process no longer runs and takes the lock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver clears a dead lock

**Feature ID:** 0000495-driver-clears-dead-lock

## Business Goal

On 2026-11-10 at 19:05 a new driver refused to start. The old driver had left `plan/.initiative-runner.lock` with the pid of a process that no longer ran. The coordinator removed the file by hand. The driver now handles that case itself and still refuses when the process runs.

Source: backlog entry 0000496, pulled in by initiative 0000360 step 49. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Take a dead lock | As the coordinator, I start a driver when the lock names a process that no longer runs, so that I need not remove the file by hand. | must-have | 1 |
| Keep refusing a live lock | As the coordinator, I want the driver to refuse when the lock names a running process, so that two drivers never run at once. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver script `initiative-run.mjs` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-runner.lock` | ravintio-zero (the driver) | The watcher and the status script read it |

### Integration Points

None change.

## Stack

| Concern | Decision |
|---------|----------|
| Language | JavaScript (Node ES modules) |
| Testing | Bash test files with `helpers/assert.sh` |
| CI | GitHub Actions |
| Build target | ci-only |

## Scope Boundaries

### In Scope
- The driver reads the lock when `wx` fails with `EEXIST`. It takes the lock if the pid no longer runs.
- The driver prints one line when it takes a dead lock.
- Tests for both outcomes. Updates to the driver header comment and `roadmap-standards.md`.

### Out of Scope
- The `--handoff` path.
- `resume-detect.mjs` and the watcher. They report "driver lock held" for a dead lock, and nothing here changes them.
- Any change to a hook guard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The driver never takes a lock whose process runs, or whose content it cannot read | Tests for a live pid, a non-numeric lock, and a symlink |

## Constraints and Assumptions

### Constraints
- The driver stays the one writer of the lock. A step session never touches it.
- The driver adds no dependency.

### Assumptions
- A reused pid reads as alive. The driver then refuses, which is the safe error.

## Scenario Paths

**Happy path:** The lock holds a pid with no process. The driver prints a line that names the pid, takes the lock, and runs the initiative. It releases the lock on exit.

> The lock holds a dead pid, and the driver starts.

**First-run path:** No lock exists. The driver writes it as before.

> No change.

**Error / sad path:** The lock holds a running pid, text that is not a pid, or is a symlink. The driver stops with the existing `exists, another driver may be running` line and leaves the file alone.

> The driver refuses and leaves the lock.

**Cross-session continuity:** Two drivers start together against one dead lock. The first removes it and writes its pid with `wx`. The second finds a live pid or fails `wx` and refuses.

> The `wx` write decides the race. Only one driver gets the lock.

## Acceptance Criteria

- [ ] If the lock names a dead process, the driver prints its pid, takes the lock, and runs.
- [ ] With a lock that holds the pid of a running process, the driver stops with the existing refusal and leaves the lock unchanged.
- [ ] If the lock holds text that is not a pid, or is a symlink, the driver refuses and leaves it unchanged.
