---
title: "Scope - Plan checks"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Plan checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000384-plan-checks
**Version:** 0.63.0

> All three sections must be present.

## In Scope

- Checks 9 and 10 in `consistency-check.mjs`, and the `Shared resources` column in check 8.
- `design.template.md` `## Component Paths`, the dispatch template commit limit, and the plan skill text for each check.
- `docs/adr/` with `.next-id`, the ADR template `Component` field, the plan and ship skill changes, and migration 0009 with its tests.
- `human-settings-check.mjs` and the plan skill step that runs it.

## Out of Scope

- Per-component ADR folders.
- Any hook change.
- Light discovery (step 11).
- Refreshing the installed `.claude/skills/` copy.

## Deferred

- Refreshing the installed copy waits for the driver `Setup:` stop after merge.
