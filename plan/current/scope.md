---
title: "Scope - CI duration metric"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - CI duration metric

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Version:** 0.87.0

## In Scope

- A `CI duration:` marker and a `ci-duration-seconds` metric in `workflow-metrics.mjs`.
- A marker definition and a threshold row in `workflow-governance-standards.md`.
- A CI target in `testing-standards.md`.
- A marker line in the ship skill's CI wait.
- A new suite, ADR-0308, docs, and a changelog entry.
- The sync of `ravintio-zero/` with `sync-installed.mjs`.

## Out of Scope

- A hook or CI job that fails on a slow run.
- Reads from GitHub inside the script.
- A history of CI runs across features.

## Deferred

Nothing deferred.
