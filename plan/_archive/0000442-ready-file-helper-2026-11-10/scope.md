---
title: "Scope - ready file helper"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - ready file helper

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Version:** 0.81.0

## In Scope

- `initiative-ready.mjs` with `--pr {n}` and `--check`.
- Driver recovery of an empty or invalid `ready` file.
- Ship skill, roadmap standards, manifest, and overview text.
- Tests, an ADR, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- The merge queue.
- The `running` file.
- The read of a valid `ready` file.

## Deferred

Nothing deferred.
