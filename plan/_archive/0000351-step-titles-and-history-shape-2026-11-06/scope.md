---
title: "Scope - Step titles and history shape"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Step titles and history shape

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Version:** 0.49.0

## In Scope

- Ship titles a step PR `{feature-id}: {Feature title}` from the `Title` column.
- A `Title` column in `initiative.template.md`, used as the P0 brief title.
- `check-initiative-history.mjs` reads the chart, matches each step title exactly, and checks the N + 1 shape.
- Title rules in `roadmap-standards.md` and `commit-standards.md`, including the one-commit PR subject.
- The chart-format migration rule in the plan skill and `roadmap-standards.md`.

## Out of Scope

- Coordinator queueing, `--delete-branch`, and `reserve-id.mjs` (step 2).
- The reshape script (step 3).
- Rechecking history already delivered to `main`.
- Any change to a hook or guard.

## Deferred

- Rules 1, 2, 3, and 5 of entry 0000345. Steps 2 and 3 take them, so the entry stays in the backlog until then.
