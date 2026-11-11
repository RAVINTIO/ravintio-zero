---
title: "Feature Brief - Coordinator status view"
summary: "One status view and event notices for the initiative coordinator."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Coordinator status view

**Feature ID:** 0000450-coordinator-status-view

## Business Goal

The coordinator missed a ready line for 24 minutes and a driver exit for two hours in initiative 0000360. It also gave a wrong status twice. A single status view and event notices let the coordinator report the run state without reading logs by hand.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Status view | As a coordinator, I run one command that shows the queue, ready PRs, running steps, and live stops, so that I report the true state. | must-have | 1 |
| Watcher events | As a coordinator, I see an event when a step becomes ready, the queue fails, or the driver exits, so that I never miss one. | must-have | 1 |
| Chart-based state | As a coordinator, I see merged steps as merged, so that stale control files never show a step as ready. | must-have | 1 |
| Report format | As a human, I read decisions apart from routine fixes, so that I oversee the run. | should-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Scripts, skills, and standards for the pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/current-initiative/initiative.md`, `plan/.initiative-control/`, step logs | ravintio-zero | none (read only for the new script) |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js scripts, Bash test suites |
| Testing | `ravintio-zero/tests/run-tests.sh` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A status script that prints queue state, ready PRs, running steps, and live stops.
- Watcher events for a new `ready` file, a queue failure, and a driver exit.
- The watcher reads the chart status, so a merged step never shows as ready or running.
- The driver prints the queue failure reason when it happens.
- A report format in the initiative skill that lists decisions apart from routine fixes.
- Standards text, tests, an ADR, docs, a changelog entry.

### Out of Scope
- Changing which stops the driver takes.
- Clearing stop lines the driver already printed.
- Any guard or hook change.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Latency | The status script exits in under 2 seconds on a 60-step chart | Timed in a test |
| Security | The script writes no file and treats file text as data | Test with a symlink and hostile text |

## Constraints and Assumptions

### Constraints
- No new library or service. The change widens no guard.

### Assumptions
- The chart `Status` column is the source of truth for merged steps.

## Scenario Paths

**Happy path:** The coordinator runs the status script during a run and sees merged, ready, and running steps with PR numbers and no live stop.

> Confirmed as drafted.

**First-run path:** With no control folder and no lock, the script prints the chart counts and says the driver is not running.

> Confirmed as drafted.

**Error / sad path:** A step blocks, or the queue fails. The script lists the stop with its step and reason. Once the step merges, the stop no longer shows.

> Confirmed as drafted.

**Cross-session continuity:** The script and watcher keep no state on disk. A new coordinator session gets the same view from the chart, control folders, and logs.

> Confirmed as drafted.

## Acceptance Criteria

- [ ] The status script prints merged, ready, running, and pending counts with PR numbers, plus live stops.
- [ ] A stop for a step that the chart marks merged does not show.
- [ ] The watcher prints an event for a new `ready` file, a queue failure, and a driver exit.
- [ ] The watcher shows a step with chart status `merged` as merged, never ready or running.
- [ ] The driver prints the queue failure reason when the queue fails.
- [ ] The initiative skill describes a report that lists decisions apart from routine fixes.
