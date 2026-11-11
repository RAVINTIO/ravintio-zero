---
title: "Feature Brief - Merge ready PRs after a stop"
summary: "The driver keeps merging independent ready PRs after one queue failure."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Merge ready PRs after a stop

**Feature ID:** 0000446-drain-ready-prs-after-a-stop

## Business Goal

After one merge queue failure, the driver holds back every other ready PR. Green, independent PRs wait for a human. The driver must keep merging them, so one failed step does not stall the others.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Drain after a queue failure | As the initiative coordinator, I want the driver to merge the other ready PRs after one queue failure, so that independent steps do not wait for a human. | must-have | 1 |
| Document the drain | As a reader of the roadmap standards, I want the drain rule written down, so that the docs match the driver. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | The driver `initiative-run.mjs` and the roadmap standards |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Control folders and step logs | ravintio-zero (driver) | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| driver | merge queue | child process | `merge-queue.mjs run --step {n} --pr {k}` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ES modules) and bash tests |
| Testing | `ravintio-zero/tests/run-tests.sh` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- The `schedule()` loop in `ravintio-zero/scripts/initiative-run.mjs` keeps queueing ready PRs after a queue failure.
- Each failure prints its own `I-D Advance: Blocked: queue stopped on step {n}` line.
- The roadmap standards describe the drain.
- A test with two ready PRs, one failing.

### Out of Scope
- A manual drain command for a stopped driver. A driver restart already queues each `ready` step.
- Starting new steps after a stop. New starts stay stopped.
- Cleaning dirty files in the queue worktree after a failure (backlog 0000477).

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | Each ready PR gets at most one queue attempt per driver run | Test counts queue calls per step |

## Constraints and Assumptions

### Constraints
- Hard Limit: the driver never force-pushes and never merges into `main`.

### Assumptions
- A ready step never shares a lane with a failed step, and it never lists the failed step in `After`. The scheduler enforces both before a step starts.

## Scenario Paths

**Happy path:** Steps 1 and 2 are ready. Step 1 fails in the queue. The driver still merges step 2, then exits 1 with the stop line for step 1.

> As written.

**First-run path:** Not applicable.

> None.

**Error / sad path:** Every ready PR fails. The driver tries each once, prints each failure, and exits 1.

> As written.

**Cross-session continuity:** A failed step keeps its `ready` file. A restarted driver queues it again.

> As written.

## Acceptance Criteria

- [ ] Steps 1 and 2 have ready PRs and the queue fails on step 1. The driver still queues step 2, and step 2 merges.
- [ ] The driver exits 1 and prints a `queue stopped on step 1` line.
- [ ] The driver runs the queue at most once per step.
- [ ] `roadmap-standards.md` states the drain rule.
