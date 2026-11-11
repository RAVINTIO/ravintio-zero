---
title: "Scope - Coordinator branches regenerate shared files"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.96.0"
---
# Scope - Coordinator branches regenerate shared files

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000505-coordinator-branch-regenerate
**Version:** 0.96.0

## In Scope

- A script `coordinator-merge.mjs` that reuses `resolveSharedConflicts` and `regenerateSharedFiles`.
- The edits live in `src/ravintio-zero/`. The sync script refreshes the installed copy `ravintio-zero/` in its own commit.
- Tests, and a rule in the Coordinator questions and commands section of `roadmap-standards.md`.

## Out of Scope

- New shared files in the allowlist.
- Any change to the merge queue.
- Pushing the branch. The coordinator pushes it.

## Deferred

Nothing deferred.
