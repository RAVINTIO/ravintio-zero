---
title: "Scope - Merge-time versioning"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Merge-time versioning

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Version:** 0.58.0

## In Scope

- `ravintio-zero/version-files.txt` and `version-files.mjs` with `check` and `set`.
- `merge-queue.mjs` with `title`, `versions`, and `run`, plus the `## Merges` table in the chart.
- Merge-order sorting by `Version` in `reshape-initiative.mjs` and `check-initiative-history.mjs`.
- Admin-commit folds in the reshape.
- Updates to the roadmap standards, the ship skill, the initiative skill, and the component manifest.

## Out of Scope

- Driver wiring to the queue. Step 3 does it.
- Removing the P4 bump. Steps 1 and 2 keep it.
- Parallel steps, worktrees, and the `Lane` and `After` columns.
- Changes to `merge-guard`.

## Deferred

- Removal of the P4 version edits is blocked until step 3 moves the driver to the queue.
