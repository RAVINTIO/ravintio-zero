---
title: "Scope - Merge queue test gaps"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Merge queue test gaps

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Version:** 0.84.0

## In Scope

- A rerun fixture and a version-mismatch fixture for `merge-queue.mjs run`.
- A dash check on the head and base names that `gh pr view` returns.
- A test for the dash check.
- The sync of `ravintio-zero/` with `sync-installed.mjs`, docs, and a changelog entry.

## Out of Scope

- Any other change to the queue flow or its output.
- Changes to the shared-file resolver or the CI wait.

## Deferred

Nothing deferred.
