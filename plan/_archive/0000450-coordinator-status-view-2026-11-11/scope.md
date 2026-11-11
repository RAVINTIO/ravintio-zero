---
title: "Scope - Coordinator status view"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Coordinator status view

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Version:** 0.95.0

## In Scope

- `initiative-status.mjs`, a read-only script for the run state and live stops.
- Watcher events for a ready file, a queue failure, and a driver exit, and chart-based state.
- The driver line for a queue failure, in stdout and in the step log.
- The report format in the initiative skill and the matching standards text.
- Four test suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- Changing which stops the driver takes.
- Clearing stop lines the driver already printed.
- Any guard or hook change.

## Deferred

Nothing deferred.
