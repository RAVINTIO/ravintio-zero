---
title: "Scope - Version files completeness check"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Version files completeness check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000466-version-files-completeness-check
**Version:** 0.88.0

## In Scope

- One test, `test-0000466-req-001-version-list-complete.sh`, with fixture cases.
- The sync of `ravintio-zero/` with `sync-installed.mjs`, docs, and a changelog entry.

## Out of Scope

- Changes to `version-files.mjs`, the merge queue, or the list format.
- Changes to the list, unless the scan finds a real omission.

## Deferred

Nothing deferred.
