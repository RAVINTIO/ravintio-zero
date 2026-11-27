---
title: "Backlog Entry: 0000599 - Restarted step keeps a stale worktree"
summary: "A restarted step reuses its worktree without a fast-forward, so it misses chart edits that landed while it was stopped."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000599 - Restarted step keeps a stale worktree

**Source feature:** none (human request)

**Source phase:** none (human request)

**Deferral source:** human request

**Date filed:** 2026-11-24

---

## Problem

In the consumer `claude-code-launcher` (pack 0.114.0), step 12 stopped on a `## Decisions` row that read "pending". The coordinator changed the row through a PR into the initiative branch. A new driver restarted the step in its old worktree, which still held the old chart, and the step stopped again. The worktree had no commits of its own. The coordinator fast-forwarded it by hand.

Two related gaps showed up in the same run:

- The merge queue waited 15 minutes on a check that GitHub still listed as in progress after the run had completed. A rerun cleared it.
- A step's `pgrep -f` wait loop matched its own shell, so the wait never ended (step 1).

## Suggested Action

Before a restart, fast-forward the step worktree onto the initiative branch when the step has no commits of its own. Stop and report when a fast-forward isn't possible. In the queue, read the workflow run's conclusion when a check stays pending past a time limit.

## Why Deferred

Found in a consumer repo during an initiative run. The fix belongs to the pack, not the consumer.
