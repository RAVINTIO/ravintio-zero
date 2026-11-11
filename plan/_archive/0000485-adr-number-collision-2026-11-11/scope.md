---
title: "Scope - Parallel steps reserve distinct ids"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Parallel steps reserve distinct ids

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000485-adr-number-collision
**Version:** 0.92.0

## In Scope

- `id-collisions.mjs`, a module that renumbers a PR ADR and a PR backlog entry when the base holds the same id.
- The queue call after the base merge, the `renumbered:` line, and the renumber commit.
- The `## Merge queue` text in `roadmap-standards.md`.
- Two test suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.
- The renumber of the second 0000479 entry to 0000515, done at P0.

## Out of Scope

- Collisions between branches that have not merged.
- Feature ids and initiative ids.
- Changes to `reserve-id.mjs`.
- The gap in the story map: the base merge itself already exists.

## Deferred

Nothing deferred.
