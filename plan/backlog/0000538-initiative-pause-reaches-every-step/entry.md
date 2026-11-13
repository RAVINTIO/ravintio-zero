---
title: "Backlog Entry: 0000538 - Initiative pause reaches every step"
summary: "On 2026-11-12 the human paused initiative 0000360, and the coordinator wrote each pause file by hand."
status: "open"
priority: "medium"
theme: "initiative"
---
# Backlog Entry: 0000538 - Initiative pause reaches every step

**Source feature:** 0000360-backlog-sweep
**Source phase:** I-C Run
**Deferral source:** human request, 2026-11-12
**Date filed:** 2026-11-12

---

## Problem

On 2026-11-12 the human paused initiative 0000360, and the coordinator wrote each pause file by hand. The orchestrator's pause command writes `plan/current/pause.md` for one feature. An initiative has no pause command of its own. The human ruled that a pause applies to each step as well as to the initiative.

Evidence: `plan/current-initiative/pause.md` and `plan/.initiative-worktrees/step-55/plan/current/pause.md`, 07:25 on 2026-11-12.

## Suggested Action

Add an initiative pause to the initiative skill and the driver:

- The driver stops starting steps and lets running sessions reach a safe point.
- It writes `plan/current/pause.md` in each running step's worktree, from the pause template.
- It writes `plan/current-initiative/pause.md` with the merged count, the remaining order, the open questions, and the resume steps.
- It stops the driver and releases the lock.
- On resume, resume detection reads the initiative pause file first, then each step's pause file.

A test pauses a run with two running steps and checks all three pause files.

## Why Deferred

Found when the human paused initiative 0000360 on 2026-11-12. The human asked for a backlog entry.
