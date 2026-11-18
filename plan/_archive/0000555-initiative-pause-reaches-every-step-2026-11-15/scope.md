---
title: "Scope - 0000555-initiative-pause-reaches-every-step"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000555-initiative-pause-reaches-every-step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000555-initiative-pause-reaches-every-step
**Version:** 0.129.0

## In Scope

- The script `initiative-pause.mjs` with `request` and `write`.
- The driver pause request in `initiative-run.mjs`, with the resume at start.
- The resume finding, the resume detection reference, the standards rules, and one skill line.
- Tests for the three requirements.

## Out of Scope

- The feature-level pause command of the orchestrator.
- A merge in progress. The queue finishes it.

## Deferred

- Nothing deferred.
