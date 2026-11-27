---
title: "Requirement: REQ-004 - Metrics row for docs"
summary: "workflow-metrics.mjs counts docs units in a row named docs."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Metrics row for docs

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Source:** US-004
**Priority:** must-have

## User Story

As a reviewer, I read the metrics report, so that I see `docs` units in their own row.

## Functional Requirements
- `CLASSIFIED_DONE` accepts class `docs`.
- The `## Dispatch by class and tier` table prints a row for each `docs` and tier pair.
- A `Rework:` marker counts toward the `docs` row when the last classified `Done:` line of its REQ id is `docs`.
- An older `Done:` line still counts as `unclassified`.

## Acceptance Criteria
- [ ] AC-1: Docs row
  - Given a log with one `Done:` line of class `docs` and tier `inline`
  - When the agent runs `workflow-metrics.mjs`
  - Then the dispatch table holds a row `docs`, `inline`, 1 unit
- [ ] AC-2: Unclassified kept
  - Given a log with an older `Done:` line
  - When the agent runs `workflow-metrics.mjs`
  - Then the dispatch table still holds an `unclassified` row

## Dependencies
- REQ-001 (the class list)
