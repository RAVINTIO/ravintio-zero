---
title: "Scope - unit dispatch"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - unit dispatch

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Version:** 0.70.0

## In Scope

- The inline unit rule in `ravintio-implement`, and the `RED:` and `GREEN:` markers.
- A `build-log-check.mjs` check on those markers.
- The class, tier, and effort table in `agent-dispatch-standards.md`, and the extended `Done:` line.
- A rework-by-class-and-tier section in `workflow-metrics.mjs`.
- ADR-0285, a changelog entry, and the living docs.

## Out of Scope

- A separate classifier skill. The table is the classifier.
- A human override of a tier at the design gate.
- Langfuse evaluation (entry 0000254).

## Deferred

- Tuning the table values. Later runs tune them from the metrics report.
