---
title: "Feature Brief - Driver keeps starting steps after a Restart"
summary: "After a merged step changes the driver, a successor driver takes over new starts at once while the running steps finish."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver keeps starting steps after a Restart

**Feature ID:** 0000493-driver-starts-after-restart

> Built from backlog entry 0000494 and the `Title` column of step 48 in initiative 0000360. The chart accepts the brief, so no human confirmation applies. Source: `draft-accepted (initiative)`.

## Business Goal

After a merged step changes the driver, the driver today starts no new step until every running step finishes. On 2026-11-10 step 26 waited from 20:01 to 21:43 for steps 36, 38, and 39. The goal is that the next ready step starts within seconds of the merge that triggers the restart.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Driver handoff | As the coordinator, I want a new driver to start new steps at once after a Restart, so that a ready step never waits for unrelated running steps. | must-have | 1 |
| Adopt running steps | As the coordinator, I want the new driver to track steps that the old driver still runs, so that no step starts twice and no merge waits. | must-have | 1 |
| Stop relay | As the coordinator, I want a block in a handed-over step to stop the new driver, so that the stop rules still hold. | must-have | 1 |
| Docs and skill text | As the coordinator, I want the standards and the initiative skill to describe the handoff, so that I do not start a second driver. | must-have | 1 |

## Waves

One wave. All four features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Driver, watcher, standards, and the initiative skill |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-control/step-{n}/` | ravintio-zero (driver) | watcher and status script, read only |
| `plan/.initiative-runner.lock` | ravintio-zero (driver) | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| old driver | successor driver | process spawn with inherited output, and the control folder | `--handoff` flag, lock pid, and a `stopped` file |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (ES modules, no dependencies) |
| Testing | bash tests with a real git fixture, stub `claude`, and stub merge queue |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A handoff on a `Restart:`-only hit in the concurrent driver.
- A successor that adopts running and ready steps from the control folders.
- A `stopped` file that carries a block from the old driver to the successor.
- Updates to the roadmap standards, the driver header, the initiative skill, and the tests.

### Out of Scope
- The serial driver path.
- A `Setup:` or `Restart: Setup:` hit. Those keep the current stop.
- Clearing a dead lock (step 49), the restart exit code (step 53), and worktree removal (step 52).

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Start delay | The successor starts a ready step within 10 seconds of the triggering merge | Scheduler test with a stub `claude` |
| Safety | No step runs in two sessions, and no PR goes through the queue twice | Scheduler test asserts one start per step and one queue run per PR |

## Constraints and Assumptions

### Constraints
- Both pack trees, `ravintio-zero/` and `src/ravintio-zero/`, hold identical files.
- The driver has no dependencies beyond Node.
- The driver never edits the working tree and never force-pushes.

### Assumptions
- The coordinator's main root sits on the initiative branch, so a fast-forward brings it to the merged ref. If it does not, the driver keeps the old stop.

## Scenario Paths

**Happy path:** A step merges and changed `initiative-run.mjs`. The old driver prints a handoff line and starts a successor on the merged code. The successor starts the next ready step and queues each step the old sessions finish.

> As described.

**First-run path:** No handoff happens until a merge changes a watched file. A driver that finds no `--handoff` flag behaves as today.

> As described.

**Error / sad path:** The spawn fails, or the root cannot fast-forward. The driver keeps the existing stop. A handed-over step blocks. The old driver writes a `stopped` file, and the successor stops new starts.

> As described.

**Cross-session continuity:** If the old driver dies mid-handoff, its `running` pid is dead. The successor then restarts that step's session in the existing worktree, as a restarted driver does today.

> As described.

## Acceptance Criteria

- [ ] After a `Restart:`-only merge, the next ready step starts while an older step still runs.
- [ ] The successor never starts a session for a step that the old driver still runs.
- [ ] The successor queues a handed-over step once it writes `ready`.
- [ ] A block in a handed-over step stops new starts in the successor.
- [ ] A `Setup:` hit, a spawn failure, and the serial path keep today's stop.
- [ ] The standards, the driver header, and the initiative skill describe the handoff.
