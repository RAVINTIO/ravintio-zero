---
title: "Scope - Two open entries share one backlog id"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Two open entries share one backlog id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000552-duplicate-backlog-ids
**Version:** 0.139.0

## In Scope

- A duplicate id check in `backlog-index.mjs --check`.
- One new suite with two folders that share an id.
- ADR 0350 that records why the check stays out of the generate mode.

## Out of Scope

- A duplicate check in the generate mode and `--review`.
- Renumbering. No duplicate exists on the base.

## Deferred

- None.
