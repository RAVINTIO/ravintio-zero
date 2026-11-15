---
title: "Feature Brief - A failed queue run can leave written files in the queue worktree"
summary: "The merge queue restores the files it wrote when a run fails before the commit lands."
status: "approved"
version: "0.1.0"
---
# Feature Brief - A failed queue run can leave written files in the queue worktree

**Feature ID:** 0000546-queue-failure-leaves-dirty-files

## Business Goal

`merge-queue.mjs` `run` writes the version files and the chart, then stages and commits them. If the commit or the push fails, the written files stay changed in the queue worktree. The next run stops with `working tree is not clean`, and the human must clean the worktree by hand. The queue must restore the files it wrote, so a rerun starts clean.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Restore written files on failure | As the driver, I run the queue after a failed run, so that the queue worktree holds no files the failed run wrote. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds `merge-queue.mjs` |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| queue worktree | ravintio-zero | none |

## Scope Boundaries

### In Scope
- On a failure after the write and before the commit lands, restore the version files and the chart to HEAD.
- Restore only the paths the queue wrote, in the queue worktree.
- A test with a commit that a hook rejects.

### Out of Scope
- Any reset of paths the queue did not write.
- A change to the clean-tree check at the start of `run`.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] A commit that a hook rejects leaves the version files and the chart equal to HEAD.
- [ ] A file the queue did not write stays as it was.
