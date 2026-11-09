---
title: "Scope - the merge queue waits for GitHub before it merges"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - the merge queue waits for GitHub before it merges

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000411-queue-waits
**Version:** 0.72.0

## In Scope

- The head, CI, and mergeability waits in `cmdRun` of `merge-queue.mjs`.
- One retry of `gh pr merge` on a transient error.
- The fake `gh` in the 0000378 and 0000405 suites.
- One new suite, `test-0000411-req-001-queue-waits.sh`.
- A changelog entry. No version bump, because this PR is not a chart step.

## Out of Scope

- Regenerating shared files on a conflict. It stays in the next initiative.
- Any change to `merge-guard` or branch protection.

## Deferred

Nothing deferred.
