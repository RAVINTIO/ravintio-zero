---
title: "Feature Brief - Delivery cleans up driver state"
summary: "After the human merges the initiative PR, I-E Delivery archives the driver logs and control files and removes the worktrees."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Delivery cleans up driver state

**Feature ID:** 0000581-delivery-cleans-up-driver-state

## Business Goal

I-E Delivery leaves the driver state of the delivered initiative in `plan/`. Initiative 0000360 left 17 `running` and `ready` files and every step log. The next initiative reuses step numbers. Its driver read a stale `running` file as a step to resume. The status script reported 16 running steps. On 2026-11-14 the coordinator moved both folders by hand. Delivery now cleans up the driver state itself.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Cleanup script | As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`. | must-have | 1 |
| Delivery text | As the coordinator, I read the cleanup in I-E Delivery and the final report, so that I run it every time. | must-have | 1 |

## Waves

One wave.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Delivery script, standards, initiative skill, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-control/`, `plan/.initiative-logs/` | ravintio-zero | none |

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node (script), bash (tests) |
| Testing | bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/initiative-cleanup.mjs`, mirrored from `src/ravintio-zero/scripts/`.
- The script refuses while a driver holds `plan/.initiative-runner.lock`.
- It moves `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`.
- It removes each worktree under `plan/.initiative-worktrees/` and runs `git worktree prune`.
- It leaves `plan/.initiative-queue/` in place and reports each remaining item.
- A new step in I-E Delivery, a final-report item, and the matching lines in the initiative skill.
- A test that a cleaned root gives `merged 0, ready 0, running 0` from `initiative-status.mjs`.

### Out of Scope
- Cleaning up a running driver or an unmerged initiative.
- Deleting `plan/.initiative-queue/` items.

### Deferred
- None.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The script deletes nothing outside `plan/` and the repo git folder, and never follows a symlink | test |

## Constraints and Assumptions

### Constraints
- A failed removal prints a `Kept:` line and never stops the run (0000501 ADR-0326).
- No pack script deletes a path by name in a shared temp folder (0000583).

### Assumptions
- The coordinator runs the script from the main working tree after the human merges the initiative PR.

## Scenario Paths

**Happy path:** The driver has stopped, the human merged the PR, and the coordinator runs the script. Both folders move to `.git/ravintio-archive/`, the worktrees go, and `initiative-status.mjs` reports zero merged, ready, and running steps for a new chart.

> See above.

**First-run path:** No `plan/.initiative-control/` or `plan/.initiative-logs/` exists. The script prints a `Kept:` line for each missing folder and exits 0.

> See above.

**Error / sad path:** A driver holds the lock. The script prints a `Blocked:` line and changes nothing. An archive target already exists. The script adds a numeric suffix and never overwrites it.

> See above.

**Cross-session continuity:** A move that stops partway leaves each folder in one place. A rerun moves what remains.

> See above.

## Acceptance Criteria

- [ ] The script refuses while the lock file exists and changes nothing.
- [ ] The script moves the logs and control folders to `.git/ravintio-archive/{id}-{slug}/` and leaves `plan/.initiative-queue/` in place with a report of each item.
- [ ] The script removes each worktree under `plan/.initiative-worktrees/` and prunes.
- [ ] I-E Delivery, the initiative skill, and the final report name the cleanup, and a test checks the text.
- [ ] A cleaned root gives `merged 0, ready 0, running 0` from `initiative-status.mjs`.
