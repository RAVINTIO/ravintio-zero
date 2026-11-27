---
title: "Scope - Log a non-TDD unit with a class"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Log a non-TDD unit with a class

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Version:** 0.151.0

## In Scope

- Class `docs` in `agent-dispatch-standards.md`, with its tier row and the rule `dispatch-docs-markers`.
- A `--class` option on `build-log-mark.mjs` for `RED` and `GREEN` lines.
- A check 7 change in `build-log-check.mjs` that requires both markers for a `docs` `Done:` line.
- A `docs` row in the `workflow-metrics.mjs` dispatch table.
- The marker example in `build-log.template.md` and the class list in `docs/architecture-overview.md`.
- ADR 0353 and four new tests, one per requirement.

## Out of Scope

- Any relaxation of a check in `build-log-check.mjs`.
- A new tier value.
- A rewrite of archived build logs.

## Deferred

Nothing deferred.
