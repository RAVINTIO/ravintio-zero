---
title: "Scope - Add-step writes the full feature id"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Add-step writes the full feature id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000438-add-step-writes-full-feature-id
**Version:** 0.77.2

## In Scope

- The helper writes `{featureId}-{slug}` in the Feature id cell.
- `initiative-chart.mjs` exports `FEATURE_ID`.
- A test for AC-1 to AC-3 in a new test file.
- The installed copy in `ravintio-zero/` matches the source.

## Out of Scope

- Edits to `initiative-run.mjs`. A change to it triggers the restart stop, and steps 24 to 27 edit it next.
- Other chart fields and tables.
- The backlog entry format.

## Deferred

Nothing deferred.
