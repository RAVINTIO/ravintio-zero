---
title: "Scope - steps read their queue items"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - steps read their queue items

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Version:** 0.87.0

## In Scope

- `initiative-queue.mjs` with `list` and `check`.
- The driver start and continue prompts name the items that name the step.
- The rules in `roadmap-standards.md` and the pickup step in the orchestrator references call the helper.
- A suite, ADR-0307, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- How the coordinator writes items.
- Any move, rename, or delete of a queue item by a step.
- A hook that blocks a PR with a missed item.

## Deferred

Nothing deferred.
