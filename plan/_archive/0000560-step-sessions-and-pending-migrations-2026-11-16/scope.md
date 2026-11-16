---
title: "Scope - Step sessions meet pending migrations"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Step sessions meet pending migrations

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000560-step-sessions-and-pending-migrations
**Version:** 0.141.0

## In Scope

- One new suite for ledger rows with a true Detect line.
- The removal of backlog entry 0000403.

## Out of Scope

- Any change to `resume-detect.mjs`.
- Any change to the resume reference or to rule `icrun-migration`.

## Deferred

- None.
