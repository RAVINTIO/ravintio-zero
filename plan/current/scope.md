---
title: "Scope - block forced adds"
summary: "Boundaries for the forced-add work."
status: "active"
version: "0.43.0"
---
# Scope - block forced adds

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000317-block-forced-adds
**Version:** 0.43.0

## In Scope

- An orchestrator skill rule against `git add -f`.
- The `block-forced-add.mjs` guard and its wiring in `setup.sh` and `setup.ps1`.
- Tracked `.gitignore` entries for the driver paths.
- An ignored-file check in the ship skill and in both CI workflows.
- Tests and docs for each change.

## Out of Scope

- Changes to what any existing guard blocks.
- A Codex hook for the new guard.
- Other ways to stage an ignored file, such as `git update-index --add`.

## Deferred

- Nothing deferred.
