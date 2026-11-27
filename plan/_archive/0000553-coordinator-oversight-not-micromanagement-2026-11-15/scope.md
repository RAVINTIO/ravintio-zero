---
title: "Scope - 0000553-coordinator-oversight-not-micromanagement"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000553-coordinator-oversight-not-micromanagement

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000553-coordinator-oversight-not-micromanagement
**Version:** 0.119.0

## In Scope

- The Reports section of the initiative skill relays watcher lines only at phase events, blocks, and stops.
- The skill tells the coordinator to read step test output only after a stop.
- A new test checks both rules. The 0000240 pin on the old relay text changes.
- The roadmap standards line that repeats the old relay rule changes.

## Out of Scope

- The OpenTelemetry baseline. That data lives outside the repo.
- Changes to `initiative-watch.mjs`.

## Deferred

Nothing deferred.
