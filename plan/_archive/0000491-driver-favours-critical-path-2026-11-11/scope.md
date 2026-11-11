---
title: "Scope - Driver favours the critical path"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Driver favours the critical path

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000491-driver-favours-critical-path
**Version:** 0.101.0

## In Scope

- A chain length for each pending step in `initiative-chart.mjs`.
- The start order of `readySteps`, longest chain first.
- Text in `roadmap-standards.md` that states the order.
- One test suite, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- Concurrency limits, lane assignment, and the merge queue order.
- Any change to the chart format.
- A weight for the time each step takes.

## Deferred

Nothing deferred.
