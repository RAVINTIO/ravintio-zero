---
title: "Feature Brief - Driver keeps uncommitted entries from a worktree"
summary: "The driver refuses to remove a step worktree that holds untracked backlog entries, and ship commits each entry the step files."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Driver keeps uncommitted entries from a worktree

**Feature ID:** 0000497-keep-worktree-entries

## Business Goal

On 2026-11-10 step 40 filed backlog entry 0000480 in its worktree and did not commit it. The queue removes the worktree with `git worktree remove --force`, so the entry would have gone with it. The coordinator saved a copy by hand. The driver now refuses to remove a worktree that holds untracked backlog entries, and ship checks that the step committed every entry it filed.

Source: backlog entry 0000498, pulled in by initiative 0000360 step 50. Bump: minor.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Keep untracked entries | As the coordinator, I want the driver to stop before it removes a worktree that holds untracked backlog entries, so that no filed entry is lost. | must-have | 1 |
| Remove a clean worktree | As the coordinator, I want the driver to remove a worktree with no untracked entries as before, so that the queue keeps merging. | must-have | 1 |
| Commit filed entries | As a step session, I check that I committed each backlog entry I filed before I raise the PR, so that the squash carries it. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver script `initiative-run.mjs` and the ship skill |

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
- `removeWorktree()` in `initiative-run.mjs` lists untracked files under `plan/backlog/` in the worktree. If any exist, it stops the queue for that step and names the files.
- A ship rule that lists untracked entries under `plan/backlog/` and commits each one by explicit path before the PR.
- Tests for both outcomes. Updates to the driver header comment and `roadmap-standards.md`.

### Out of Scope
- Moving the entries to the main tree's queue. The driver refuses and reports, as the entry allows.
- Untracked files outside `plan/backlog/`.
- Removal of merged worktrees that nobody removes (step 52).
- Any change to a hook guard.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The driver never deletes an untracked backlog entry, and never removes a worktree when git cannot list its files | Tests for an untracked entry and a failed listing |

## Constraints and Assumptions

### Constraints
- The driver stays the only remover of step worktrees. A step session never removes one.
- The driver adds no dependency.

### Assumptions
- `git ls-files --others --exclude-standard` lists every untracked, non-ignored file under `plan/backlog/`. Ignored files are not entries.

## Scenario Paths

**Happy path:** The worktree holds an untracked entry. The queue stops on that step with a line that names the file. The worktree stays and the step keeps its `ready` file.

> The entry survives, and the coordinator commits it.

**First-run path:** The worktree holds no untracked entries. The driver removes it and runs the queue as before.

> No change.

**Error / sad path:** Git cannot list the files. The driver treats the worktree as unsafe and stops the queue for that step.

> The driver keeps the worktree and reports the git error.

**Cross-session continuity:** The queue stops. A new driver finds the worktree still in place and repeats the check.

> The check is stateless, so a rerun gives the same answer.

## Acceptance Criteria

- [ ] If the step worktree holds an untracked file under `plan/backlog/`, the driver keeps it and stops the queue. The stop line names the file.
- [ ] If the step worktree holds none, the driver removes it and runs the queue as before.
- [ ] If git cannot list the files, the driver keeps the worktree and stops the queue.
- [ ] The ship skill tells a step to commit each backlog entry it filed, by explicit path, before the PR.
