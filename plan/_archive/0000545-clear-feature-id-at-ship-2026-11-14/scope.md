---
title: "Scope - 0000545-clear-feature-id-at-ship"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000545-clear-feature-id-at-ship

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Version:** 0.115.0

## In Scope

- Ship Step 8 deletes `plan/.feature-id`.
- `shared-files.mjs` resolves `plan/.feature-id`.
- The PR deletes the tracked file.
- Two new tests and the pin updates they need.

## Out of Scope

- Other sentinels.
- Resume detection logic.

## Deferred

Nothing deferred.
