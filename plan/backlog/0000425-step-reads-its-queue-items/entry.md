---
title: "Backlog Entry: 0000425 - Steps find and act on their queue items"
summary: "Steps find and act on their queue items, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000425 - Steps find and act on their queue items

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

Steps missed queue items that named them. Step 13 read an empty worktree queue. Step 17 ran `cat` on item folders and never read `item.md`. Step 18 never read `narrow-brand-guard-self-entry`, which still sits in the queue. The start prompt names no item, and no check compares the queue with the step diff.

Evidence rows: 8, 19, and 25. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

List the items whose `**Step:**` line names the step in the start prompt. Add a ship check that fails when an item that names the step has no commit or report.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
