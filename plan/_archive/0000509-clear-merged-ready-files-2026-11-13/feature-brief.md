---
title: "Feature Brief - Driver clears ready files of merged steps"
summary: "At start, the driver removes the ready file of every merged step and reports each one it clears or keeps."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver clears ready files of merged steps

**Feature ID:** 0000509-clear-merged-ready-files

## Business Goal

Merged steps leave `ready` files in `plan/.initiative-control/`. On 2026-11-11 the coordinator removed 7 of them by hand, for steps 10, 11, 13, 16, 18, 20, and 34. The driver now clears them.

Source: backlog entry 0000510, pulled in by initiative 0000360 step 56. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Clear merged ready files | As the coordinator, I want the driver to remove the `ready` file of a merged step and report it, so that I do not clear them by hand. | must-have | 1 |
| Keep a ready file when a session runs | As the coordinator, I want the driver to leave the control folder of a live session alone, so that a running step loses no state. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver script `initiative-run.mjs` and `roadmap-standards.md` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-control/step-{n}/` | ravintio-zero (the driver) | The step session writes `ready` and `running` there |

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
- A pass in `schedule()` of `initiative-run.mjs`. For each chart step with status `merged`, it removes `plan/.initiative-control/step-{n}/ready`.
- The pass prints `I-C Run: Cleared: step {n} ready file of a merged step` for each file it removes.
- The pass keeps the file and prints `I-C Run: Kept: step {n} {reason}` when a `running` file names a live pid, or when the file cannot be removed.
- Tests, the driver header comment, `roadmap-standards.md`, and one ADR.

### Out of Scope
- Control folders of unmerged steps.
- Removing the `running` file, `stopped` file, or the folder itself.
- Worktrees and branches.
- Any change to a hook guard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The pass never removes a file of an unmerged step, never removes one while a session runs, and never stops the run | Tests for each case |

## Constraints and Assumptions

### Constraints
- The driver stays the only remover of control files.
- The driver adds no dependency.
- A kept file never stops the run.
- The driver refuses a symlink at the control path, as `readControl()` does.

### Assumptions
- A merged step has no use for `ready`, because the chart already records the merge.

## Scenario Paths

**Happy path:** The chart marks step 10 merged and `plan/.initiative-control/step-10/ready` exists. The driver removes it at start and prints a `Cleared:` line.

> The file is gone.

**First-run path:** No merged step has a control folder. The pass does nothing and prints nothing.

> No change.

**Error / sad path:** A `running` file names a live pid, or the removal fails. The driver keeps the file and prints a `Kept:` line.

> The run continues.

**Cross-session continuity:** The pass is stateless, so the next driver start repeats it.

> The driver clears a file that it kept once as soon as that is safe.

## Acceptance Criteria

- [ ] The driver removes the `ready` file of a merged step at start and prints a `Cleared:` line.
- [ ] The driver leaves the `ready` file of an unmerged step alone.
- [ ] The driver keeps the `ready` file of a merged step whose `running` file names a live pid.
- [ ] The driver prints nothing for a merged step with no `ready` file.
- [ ] A removal failure prints a `Kept:` line and never stops the run.
