---
title: "Scope - Plan lists the change shapes a diff reader must handle"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Plan lists the change shapes a diff reader must handle

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000577-plan-lists-change-shapes
**Version:** 0.137.0

## In Scope

- A `Diff reader` cause in `skills/ravintio-plan/references/test-impact-causes.md`.
- A merge of the `New test file` and `Non-suite file` causes into one line.
- One new suite that checks the cause.

## Out of Scope

- A script that finds diff readers.
- A higher scan cap.

## Deferred

- None.
