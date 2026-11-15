---
title: "Scope - Test impact scan misses suites that scan live files"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Test impact scan misses suites that scan live files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000566-test-impact-for-history-moves
**Version:** 0.124.0

## In Scope

- A `History move` cause in `references/test-impact-causes.md`.
- One new suite that checks the cause.

## Out of Scope

- Causes that steps 23 to 27 add.
- Hook and script changes.

## Deferred

- Nothing deferred.
