---
title: "Scope - Delivery cleans up driver state"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Delivery cleans up driver state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Version:** 0.151.0

## In Scope

- `scripts/initiative-cleanup.mjs`, which refuses while `plan/.initiative-runner.lock` exists.
- A move of `plan/.initiative-logs/` and `plan/.initiative-control/` to `.git/ravintio-archive/{id}-{slug}/`.
- Removal of each worktree under `plan/.initiative-worktrees/` and a `git worktree prune`.
- A `Kept:` line for each item left in `plan/.initiative-queue/`.
- A cleanup step in I-E Delivery, a final-report item, and the matching lines in the initiative skill.
- Tests for each requirement, mirrored in `src/ravintio-zero/` and `ravintio-zero/`.
- Living docs for the new script.

## Out of Scope

- Cleaning up an initiative that has not merged.
- Deleting or moving items in `plan/.initiative-queue/`.
- Removing entries that earlier initiatives leaked.

## Deferred

Nothing deferred.
