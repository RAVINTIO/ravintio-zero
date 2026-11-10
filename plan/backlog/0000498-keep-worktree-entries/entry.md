---
title: "Backlog Entry: 0000498 - Driver keeps uncommitted entries from a worktree"
summary: "On 2026-11-10 step 40 filed backlog entry 0000480 in its worktree and did not commit it."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000498 - Driver keeps uncommitted entries from a worktree

**Source feature:** 0000497-keep-worktree-entries
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-10
**Date filed:** 2026-11-10

---

## Problem

On 2026-11-10 step 40 filed backlog entry 0000480 in its worktree and did not commit it. When the worktree goes, the entry goes with it. The coordinator saved a copy by hand.

Evidence: `plan/.initiative-worktrees/step-40` at 23:10 on 2026-11-10.

## Suggested Action

before the driver or the queue removes a step worktree, it lists untracked files under `plan/backlog/` and moves them to the main tree's queue, or refuses and reports them. Ship also checks that every entry the step filed is committed.

## Why Deferred

Found during I-C Run of initiative 0000360, after the step 22 retrospective. The human asked for it as its own step.
