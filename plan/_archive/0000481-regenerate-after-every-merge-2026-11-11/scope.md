---
title: "Scope - Regenerate shared files after every base merge"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.92.0"
---
# Scope - Regenerate shared files after every base merge

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000481-regenerate-after-every-merge
**Version:** 0.92.0

## In Scope

- `regenerateSharedFiles` in `shared-files.mjs`.
- A call to it in `merge-queue.mjs` after every base merge, with a commit before the push.
- The edits live in `src/ravintio-zero/`. The sync script refreshes the installed copy `ravintio-zero/` in its own commit.
- Tests, and an update to the Shared files section of `roadmap-standards.md`.

## Out of Scope

- New shared files in the allowlist.
- Any change to conflict resolution.

## Deferred

Nothing deferred.
