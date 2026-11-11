---
title: "Scope - Steps apply the chart's Decisions rows"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - Steps apply the chart's Decisions rows

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Version:** 0.95.0

## In Scope

- `decision-rows.mjs`, a module that lists the Decisions rows for a step.
- Check 9 in `build-log-check.mjs`.
- A P0 start action and the `roadmap-standards.md` text.
- Three test suites, one ADR, docs, a changelog entry, and the sync to `ravintio-zero/`.

## Out of Scope

- Judging whether a step applied a row well. The check requires a log line only.
- Changes to the chart table format.
- Changes to the driver.

## Deferred

Nothing deferred.
