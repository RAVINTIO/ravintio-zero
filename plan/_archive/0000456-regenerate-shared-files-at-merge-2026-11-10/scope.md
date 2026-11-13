---
title: "Scope - Regenerate shared files at merge"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Regenerate shared files at merge

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000456-regenerate-shared-files-at-merge
**Version:** 0.81.0

## In Scope

- The `shared-files.mjs` resolver and its call from `merge-queue.mjs`.
- Counter, backlog index, decisions index, and architecture overview rules.
- The `--base` overlap check in `coordinator-pr-check.mjs`.
- Docs for both, and two test suites.

## Out of Scope

- A generator for the prose of `architecture-overview.md`.
- Resolving conflicts in any other file.

## Deferred

Nothing deferred.
