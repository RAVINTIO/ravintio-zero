---
title: "Backlog Entry: 0000429 - The queue recovers cleanly after a failed run"
summary: "The queue recovers cleanly after a failed run, from the initiative 0000360 retrospective."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000429 - The queue recovers cleanly after a failed run

**Source feature:** 0000421-initiative-retrospective

**Source phase:** P2

**Deferral source:** discovered mid-flight

**Date filed:** 2026-11-10

---

## Problem

A failed queue run leaves a `chore: set version` commit on the step branch, and the next merge conflicts on the version rows. The queue worktree also stays on a step branch, so a restart cannot check that branch out. Coordinators fixed both by hand. Entry 0000400 covers the rerun test only.

Evidence rows: 13 and 14. See `plan/retrospectives/0000360-backlog-sweep-retrospective.md`.

## Suggested Action

Take the base version rows before the queue sets a version. Detach the queue worktree after every run, including a failed run. Add a restart test.

## Why Deferred

Step 22 only records findings. Each fix is its own later step.
