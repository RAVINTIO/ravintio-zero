---
title: "Backlog Entry: 0000517 - Step base merge regenerates the backlog index"
summary: "A step that merges the initiative branch by hand leaves the backlog index stale, and CI fails."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000517 - Step base merge regenerates the backlog index

**Source feature:** 0000450-coordinator-status-view

**Source phase:** P4

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-11

---

## Problem

Step 29 merged the initiative branch into its feature branch by hand before the PR, because the PR conflicted. The merge left `plan/backlog/index.md` stale. CI failed twice on `backlog-index.mjs --check`, in `validate-branch` and in `bash-suites shard 3`. The step rebuilt the index in one more commit.

Since 0000481 the merge queue regenerates shared files after every base merge. A step that merges by hand has no such help, and the ship skill does not say to rebuild the index.

## Suggested Action

Add one line to the I-D Advance text in `roadmap-standards.md`. After a manual base merge, run `node ravintio-zero/scripts/backlog-index.mjs` and commit the result before the push. Name the check that fails if the index is stale.

## Wanted outcome

I-D Advance says to run `backlog-index.mjs` after a manual base merge, and it names the CI check that fails otherwise. A standards test checks the line.

The human approved this outcome at the chart of initiative 0000544 on 2026-11-14.

## Why Deferred

The step's scope is the coordinator status view. The CI failure cost one extra push and no data.
