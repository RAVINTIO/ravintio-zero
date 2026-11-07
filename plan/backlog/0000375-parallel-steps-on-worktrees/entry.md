---
title: "Backlog Entry: 0000375 - the driver runs independent steps at once in worktrees"
summary: "The driver runs one step at a time in one working tree, so a long initiative takes as long as all its steps added up."
status: "open"
priority: "high"
theme: "initiative"
---
# Backlog Entry: 0000375 - the driver runs independent steps at once in worktrees

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-11-07

---

## Problem

`initiative-run.mjs` holds one lock, `plan/.initiative-runner.lock`, and reads one `**Position:**`. It runs one `claude -p` step session at a time in the main working tree. The step reads one `plan/current/build-log.md`. The watcher assumes one current step. Steps that touch different files still wait for each other. The repo `CLAUDE.md` also says "Don't use git worktrees".

## Suggested Action

- Add `Lane` and `After` columns to the chart's `## Steps` table. Steps in the same lane run in chart order. A step waits for every step that `After` names.
- The driver runs up to the chart's `**Concurrency:**` steps at once, each in its own `git worktree` cut from the initiative branch head. A step is ready when its row is `pending`, its `After` steps have merged, and no running step shares its lane.
- Track per-row status `pending`, `running`, `ready`, or `merged` in the chart. Keep one log and one control area per step. The lock covers the driver, not a step.
- On a `Blocked:`, `Question:`, `Restart:`, or `Setup:` line from any step, stop starting new steps. Let the others reach a safe point, then stop. Report each step's state.
- The watcher reports each running step.
- Scope the `CLAUDE.md` worktree rule to human sessions, in the pack template and in this repo.

## Wanted outcome

Independent steps of one initiative run at the same time. Tests check these conditions:

- A driver test with two stub steps in different lanes runs both at once and merges both through the queue from 0000374.
- Two stub steps in the same lane, or linked by `After`, run one after the other.
- A `Blocked:` line in one running step stops the driver from starting new steps, and the report names every step's state.
- The pack's `CLAUDE.md` template allows driver-run worktrees and still tells a human session to work on a `feat/` branch in the main working tree.

Concurrent steps are the standard way to run an initiative, for every user of the pack. Tests check these conditions:

- `initiative.template.md` holds `Lane` and `After` columns and a `**Concurrency:**` field with a default of 3. A value of 1 runs steps one at a time.
- I-A Chart in `roadmap-standards.md` and the initiative skill coach the lane and `After` of each step. Steps that edit the same files share a lane, and a step that changes most files runs alone.
- The I-C Run, I-D Advance, and I-E Delivery sections describe concurrent steps and the merge queue as the normal flow.
- The initiative skill reports each running step in interval and progress reports.

## Why Deferred

The human asked for concurrent steps on worktrees on 2026-11-07. It needs 0000374 first.
