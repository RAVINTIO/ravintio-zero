---
title: "Scope - 0000554-coordinator-starts-defined-stages"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - 0000554-coordinator-starts-defined-stages

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000554-coordinator-starts-defined-stages
**Version:** 0.126.0

## In Scope

- Rule `coord-defined-stage` in `roadmap-standards.md`.
- One initiative skill line that I-E Delivery starts with no question after a clean end.
- The new clean-end action text in `initiative-run.mjs` and rule `driver-stop-summary`.
- The updated pin in `test-0000511-req-001-003-stop-summary.sh` and a new rule check in `test-0000399-req-003-004-question-rule.sh`.

## Out of Scope

- Any change to the human-only actions. The human still merges the initiative PR into `main`.
- Any change to the `Restart:`, `Setup:`, or other stop actions.

## Deferred

- Nothing deferred.
