---
title: "Backlog Entry: 0000610 - Initiative cleanup keeps a worktree with uncommitted files"
summary: "initiative-cleanup.mjs removes each step worktree with --force, which drops uncommitted work. It should keep such a worktree and print a Kept line."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000610 - Initiative cleanup keeps a worktree with uncommitted files

**Source feature:** 0000581-delivery-cleans-up-driver-state (ADR-0354)

**Source phase:** I-E Delivery

**Deferral source:** `plan/retrospectives/0000544-priority-backlog-initiative-2026-11-27.md`

**Date filed:** 2026-11-27

---

## Problem

`initiative-cleanup.mjs` runs `git worktree remove --force` on each folder under `plan/.initiative-worktrees/`. The flag removes a worktree even when it holds uncommitted or untracked files. In initiative 0000544, steps 36 and 37 ended with committed but unpushed work. A step that ends with uncommitted work would lose it at cleanup.

## Suggested Action

- The script runs `git worktree remove` without `--force`.
- If a worktree has uncommitted or untracked files, other than ignored files such as `.t/`, the script keeps it. It prints `Kept: {path} has uncommitted files`.
- If a worktree's branch has commits that are not on `origin`, the script keeps it and prints `Kept: {path} has unpushed commits`.
- The final report lists each kept worktree.

## Tests

- A fixture worktree with an uncommitted file stays, and the script prints the `Kept:` line.
- A fixture worktree with an unpushed commit stays.
- The script removes a clean, pushed worktree, and `git worktree list` no longer shows it.

## Why Deferred

The initiative retrospective filed it on 2026-11-27. It changes a delivery script, so it waits for a future initiative.
