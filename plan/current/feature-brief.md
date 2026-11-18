---
title: "Feature Brief - Clean up step temp files after each merge"
summary: "The driver removes a merged step's temp paths, and suites remove their temp folders on every exit."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Clean up step temp files after each merge

**Feature ID:** 0000583-step-temp-cleanup-after-merge

## Business Goal

Step sessions and suites leave temp files behind after a step merges. On 2026-11-14 they filled the disk with 10,528 entries (26.1 GiB) and the driver stopped with `ENOSPC`. Each step's temp files go away once its feature branch merges into the initiative branch.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Driver cleanup | As the driver, I remove a merged step's `/tmp/step{n}*` paths and extra worktrees, then run `git worktree prune`, so that a merged step leaves nothing behind. | must-have | 1 |
| Suite cleanup | As a suite, I remove my temp folders on every exit, including a stop signal, so that no `ravintio_*` entry outlives the run. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Driver script, test suites, standards |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| user temp folder | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (driver), bash (suites) |
| Testing | bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Driver cleanup after the queue merges a step.
- Exit traps in the four named suites, `0000029`, and the git-isolation helper.
- Tests for both.

### Out of Scope
- Deleting leaked entries from earlier runs.
- PowerShell suites.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | Cleanup never stops the run and never follows a symlink | test |

## Constraints and Assumptions

### Constraints
- A kept or failed cleanup prints a `Kept:` line and never stops the driver (0000501 ADR-0326).

### Assumptions
- A suite stopped by SIGTERM or SIGINT runs its handler when the trap converts the signal to an exit.

## Scenario Paths

**Happy path:** The queue merges step n. The driver removes `/tmp/step{n}*`, any extra worktree whose path starts `step{n}`, then prunes.

> As stated.

**First-run path:** No temp path exists. The driver does nothing and prints nothing.

> As stated.

**Error / sad path:** A removal fails. The driver prints `I-C Run: Kept: step {n} {reason}` and carries on.

> As stated.

**Cross-session continuity:** A driver restart sweeps merged steps at start, so the cleanup also runs for a step that merged under an earlier driver.

> As stated.

## Acceptance Criteria

- [ ] After a merge the driver removes `/tmp/step{n}*` paths and extra step worktrees, and runs `git worktree prune`.
- [ ] A step number never matches a longer one (`step1` keeps `step10`).
- [ ] The five named suites and the helper leave no new `ravintio_*` or `ravintio-gitconfig*` entry, also when stopped by a signal.
- [ ] Docs name the cleanup.
