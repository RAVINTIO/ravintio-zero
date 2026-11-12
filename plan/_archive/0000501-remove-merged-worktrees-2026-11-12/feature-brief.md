---
title: "Feature Brief - Driver removes merged step worktrees"
summary: "At start, the driver removes the worktree of every merged step once it is safe, and reports each one it keeps."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver removes merged step worktrees

**Feature ID:** 0000501-remove-merged-worktrees

## Business Goal

On 2026-11-11 the worktree `plan/.initiative-worktrees/step-12` still existed, although step 12 merged on 2026-11-08. Nothing removes the worktree of a step that merged outside the current driver run, so old worktrees pile up and hold their branches. The driver now sweeps them.

Source: backlog entry 0000502, pulled in by initiative 0000360 step 52. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Sweep merged worktrees | As the coordinator, I want the driver to remove a merged step's worktree when it is safe, so that old worktrees do not pile up. | must-have | 1 |
| Keep and report unsafe worktrees | As the coordinator, I want the driver to keep an unsafe worktree and name its files, so that I lose no work. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver script `initiative-run.mjs` and `roadmap-standards.md` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/.initiative-worktrees/step-{n}` | ravintio-zero (the driver) | The step session writes inside its own worktree |

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
- A sweep in `schedule()` of `initiative-run.mjs`. For each chart step with status `merged`, it removes `plan/.initiative-worktrees/step-{n}` when it is safe.
- A worktree is safe when three things hold. No `running` file names a live pid. `git status --porcelain` lists nothing. The head is on the origin branch, or that branch is gone.
- A kept worktree prints one `I-C Run: Kept:` line that names the step, the reason, and up to five files.
- Tests, the driver header comment, `roadmap-standards.md`, and one ADR.

### Out of Scope
- Removing worktrees of unmerged steps.
- Deleting local or remote branches.
- Removing the queue worktree or any control folder.
- Any change to a hook guard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The sweep never removes a worktree that holds uncommitted files, unpushed commits, or a live session, and never removes one it cannot inspect | Tests for each case |

## Constraints and Assumptions

### Constraints
- The driver stays the only remover of step worktrees.
- The driver adds no dependency.
- A kept worktree never stops the run. The sweep only reports it.

### Assumptions
- A squash merge with `--delete-branch` removes `origin/feat/{id}`, so a missing origin branch for a merged step means the work reached the initiative branch.

## Scenario Paths

**Happy path:** The chart marks step 12 merged and its worktree is clean. The driver removes it at start.

> The folder is gone and `git worktree list` no longer names it.

**First-run path:** No merged step has a worktree. The sweep does nothing and prints nothing.

> No change.

**Error / sad path:** The worktree holds an uncommitted file, or git cannot inspect it. The driver keeps it and prints a `Kept:` line with the reason.

> The run continues and the coordinator deals with the worktree.

**Cross-session continuity:** The sweep is stateless, so the next driver start repeats it.

> The driver removes a worktree that it kept once as soon as it becomes safe.

## Acceptance Criteria

- [ ] The driver removes a merged step's clean worktree with no live session at start.
- [ ] The driver keeps a merged step's worktree that has an uncommitted file, and the `Kept:` line names the file.
- [ ] The driver keeps a merged step's worktree when its head is not on the origin branch that still exists.
- [ ] The driver keeps the worktree of a merged step whose `running` file names a live pid.
- [ ] The driver leaves the worktree of an unmerged step alone.
