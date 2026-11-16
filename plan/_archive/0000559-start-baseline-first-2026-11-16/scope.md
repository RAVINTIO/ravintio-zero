---
title: "Scope - Start the baseline run before the P0 artifacts"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Start the baseline run before the P0 artifacts

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000559-start-baseline-first
**Version:** 0.141.0

## In Scope

- Reorder and renumber the start actions so the decision rows and the baseline follow the pre-flight.
- Fix the cross-references to renumbered actions.
- One new suite that reads the action order.

## Out of Scope

- A change to `clean-clone-test.mjs` or `baseline-failures.mjs`.
- A change to when P3 compares results.

## Deferred

- None.
