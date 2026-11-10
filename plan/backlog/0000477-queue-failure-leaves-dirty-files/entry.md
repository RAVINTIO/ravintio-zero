---
title: "Backlog Entry: 0000477 - a failed queue run can leave written files in the queue worktree"
summary: "A queue run that fails after it writes the version files and before it commits leaves a dirty tree, and the next run stops."
status: "open"
priority: "low"
theme: "initiative"
---
# Backlog Entry: 0000477 - a failed queue run can leave written files in the queue worktree

**Source feature:** 0000454-queue-failure-recovery

**Source phase:** P1

**Deferral source:** deliberate scope decision

**Date filed:** 2026-11-10

---

## Problem

`merge-queue.mjs` `run` writes the version files and the chart, then stages and commits them. If the commit or the push fails, the files stay changed in the queue worktree. The next run stops with `working tree is not clean`. The 0000454 step detaches HEAD after every run but leaves the files alone. See `plan/current/scope.md` of that step.

## Suggested Action

On a failure after the write and before the commit lands, restore the version files and the chart to HEAD. Restore only the paths the queue wrote. Add a test with a commit that a hook rejects.

## Why Deferred

The brief for 0000454 named the version rows and the detach only. The case is rare and needs a decision on how much the queue may reset in a worktree.

Source retrospective: `plan/retrospectives/0000454-queue-failure-recovery-2026-11-10.md`.
