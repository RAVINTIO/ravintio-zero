---
title: "Feature Brief - Ship leaves plan/.feature-id behind"
summary: "Ship deletes plan/.feature-id for an initiative step, so no squash carries a stale id."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Ship leaves plan/.feature-id behind

**Feature ID:** 0000545-clear-feature-id-at-ship

## Business Goal

Each squash carries the last step's id in `plan/.feature-id` onto the initiative branch. The next base merge then conflicts on the file, and resume detection flags the stale id. Remove the cause so concurrent steps merge with no conflict on it.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Ship deletes `plan/.feature-id` | As a step session, I leave no `plan/.feature-id` in the step PR, so that the base merge never conflicts on it. | must-have | 1 |
| Queue resolves `plan/.feature-id` | As the merge queue, I resolve a base-merge conflict on `plan/.feature-id`, so that a stale id never stops the queue. | must-have | 1 |
| Remove the tracked stale file | As the initiative branch, I hold no `plan/.feature-id`, so that the next step starts clean. | must-have | 1 |

## Scope Boundaries

### In Scope
- Ship Step 8 deletes `plan/.feature-id` for an initiative step.
- `shared-files.mjs` resolves `plan/.feature-id` at a base merge.
- `git rm plan/.feature-id`.
- A test checks that no step branch carries the file after the closing push.

### Out of Scope
- Other sentinels and the resume detection logic.

## Acceptance Criteria

- [ ] Ship Step 8 deletes `plan/.feature-id` for an initiative step.
- [ ] `shared-files.mjs` resolves a conflict on `plan/.feature-id`.
- [ ] A test checks that a step branch carries no `plan/.feature-id` after Step 8.
- [ ] The PR head tracks no `plan/.feature-id`.
