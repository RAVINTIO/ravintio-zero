---
title: "Scope - refuse a step merge outside the queue"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - refuse a step merge outside the queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000458-refuse-step-merge-outside-queue
**Version:** 0.80.1

## In Scope

- The `RAVINTIO_INITIATIVE_QUEUE` check in `merge-guard.mjs`.
- A new suite, and updates to suites that pin the carve-out text.
- Carve-out text in the five documents named in REQ-001.
- ADR-0301, a changelog entry, and the sync of `ravintio-zero/`.

## Out of Scope

- `merge-queue.mjs` and the driver.
- Coordinator merges, which run without the variable.
- The `block-forced-add` and `gate-write` guards.

## Deferred

Nothing deferred.
