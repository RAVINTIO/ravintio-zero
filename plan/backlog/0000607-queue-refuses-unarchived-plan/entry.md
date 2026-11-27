---
title: "Backlog Entry: 0000607 - Merge queue refuses a step PR that still has plan/current"
summary: "merge-queue.mjs run stops before the merge when the step branch still holds plan/current/, so an unarchived run never reaches the initiative branch."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000607 - Merge queue refuses a step PR that still has plan/current

**Source feature:** 0000544-priority-backlog (initiative run)

**Source phase:** I-D Advance

**Deferral source:** human request

**Date filed:** 2026-11-27

---

## Problem

On 2026-11-27 the queue merged PR #254 for step 36. Step 36 had stopped at P4 before its archive, so the squash carried its `plan/current/` folder into the initiative branch. Step 37's branch then conflicted with that folder, and the queue stopped on step 37. The coordinator archived the folder by hand in PR #257.

Step 37 had the same gap. It logged `Complete: P4` but did not archive the plan.

Ship's archive step is the only guard. Nothing checks the branch before the merge.

## Suggested Action

- Before the merge, `merge-queue.mjs run` lists the tree of the PR head with `git ls-tree`.
- If the head holds any path under `plan/current/`, the queue stops with `I-D Advance: Blocked: step {n} PR #{k} still holds plan/current/. Archive the run before the merge.`
- The queue does not merge, push, or change the branch when it stops.
- The check also looks for the archive folder `plan/_archive/{feature-id}-*/` with a `build-report.md`. A missing report stops the queue the same way.

## Tests

- A test runs the queue on a fixture PR head that holds `plan/current/design.md`. The queue stops with the message and calls no `gh pr merge`.
- A test runs the queue on a head with no `plan/current/` and an archive with a build report. The queue merges.
- A test runs the queue on a head with no archive build report. The queue stops.

## Why Deferred

The human approved the entry on 2026-11-27 during initiative 0000544. It changes the merge queue, so it waits for a future initiative.
