---
title: "Scope - Driver stops and headroom"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Driver stops and headroom

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Version:** 0.57.0

## In Scope

- Move Context Hygiene to `references/orchestrator-context-hygiene.md` with a Pack Index row, and update the cap tests and base fixture.
- Stop the driver on an open `Question:` line, report it in the watcher, and name it in the continue prompt.
- Run the setup change check after the last step.
- Update `roadmap-standards.md`, the docs, and the tests.

## Out of Scope

- Parallel steps, merge-time versioning, and every other step of initiative 0000360.

## Deferred

Nothing deferred.
