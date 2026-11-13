---
title: "Scope - Check mergeability before a CI wait"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Check mergeability before a CI wait

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000483-mergeability-before-ci-wait
**Version:** 0.91.0

## In Scope

- `waitForChecks` in `merge-queue.mjs` reads `mergeable` and stops on `CONFLICTING`.
- A no-checks timeout in `waitForChecks`, set with `MQ_NOCHECKS_MS`, with a named error.
- A mergeability read before the CI poll in I-D Advance of `roadmap-standards.md` and in the ship skill.
- A new suite, an ADR, docs, a changelog entry, and the sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- Conflicts on files other than shared files. The queue already stops on those.
- Changes to the driver or the watcher.
- Changes to any guard or hook.

## Deferred

Nothing deferred.
