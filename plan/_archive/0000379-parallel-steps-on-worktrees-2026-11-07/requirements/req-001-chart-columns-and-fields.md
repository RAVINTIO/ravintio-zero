---
title: "Requirement: REQ-001 - Chart columns and fields"
summary: "Chart columns and fields"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Chart columns and fields

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I give each step a lane and an `After` list and set `**Concurrency:**`, so that the driver knows what may run together.

## Functional Requirements

- `## Steps` gains `Lane` and `After` columns. `After` holds step numbers and ranges such as `5-18`, or is empty.
- `**Concurrency:**` holds a whole number from 1 to 9. `initiative.template.md` defaults it to 3.
- `## Steps` `Status` accepts `pending`, `running`, `ready`, and `merged`. The committed chart holds `pending` and `merged`. The driver derives `running` and `ready` from its control area.
- `ravintio-zero/scripts/initiative-chart.mjs` parses the table by header name and returns each step's lane, `After` list, and status. A chart without the columns or the field parses as one lane per step with no `After` and a concurrency of 1.
- The active chart moves its `## Lanes` table into `## Steps`.

## Acceptance Criteria

- [ ] AC-1: the template holds the columns
  - Given `initiative.template.md`
  - When a test reads it
  - Then `## Steps` has `Lane` and `After` columns and the file holds `**Concurrency:** 3`
- [ ] AC-2: the parser reads lanes and ranges
  - Given a chart with `After` cells `5-18` and `6, 13`
  - When the parser reads it
  - Then it returns the expanded step lists
- [ ] AC-3: an old chart still parses
  - Given a chart with no `Lane`, `After`, or `**Concurrency:**`
  - When the parser reads it
  - Then it reports concurrency 1 and no lane or `After` limits

## Dependencies

- Step 2 merge queue (merged)
