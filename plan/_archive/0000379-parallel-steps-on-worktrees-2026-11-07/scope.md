---
title: "Scope - Parallel steps on worktrees"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Parallel steps on worktrees

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Version:** 0.59.0

## In Scope

- `Lane` and `After` columns, `**Concurrency:**`, and the four statuses in the template, the standards, and the active chart.
- `initiative-chart.mjs` and the scheduler, worktrees, logs, and control areas in `initiative-run.mjs`.
- Queue hand-off, the `Position` update in `merge-queue.mjs`, and the P4 change that sets no version.
- Stop rules and the state report.
- Watcher and initiative skill reports.
- The worktree rule in the boot templates and `custom-001`.

## Out of Scope

- Automatic lane inference.
- Changes to `merge-guard`.
- Per-step model or turn-cap settings.

## Deferred

- None.
