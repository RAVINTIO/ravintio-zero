---
title: "Scope - Test impact scan for layout moves"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Test impact scan for layout moves

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000565-layout-move-test-impact
**Version:** 0.123.0

## In Scope

- A `Path move` cause in `references/test-impact-causes.md`.
- One new suite that checks the cause.

## Out of Scope

- Causes that steps 22 to 27 add.
- Hook and script changes.
- The pack check that runs the suite from the new folder before P2.

## Deferred

- The pack check that runs the suite from the new folder. The backlog entry calls it optional.
