---
title: "Requirement: REQ-001 - Full feature id"
summary: "The add-step helper writes the full feature id in the Steps row."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Full feature id

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000438-add-step-writes-full-feature-id
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I add a step with the helper, so that the driver starts it with no manual fix.

## Functional Requirements

- The helper writes `{featureId}-{slug}` in the `Feature id` cell of the new Steps row.
- `initiative-chart.mjs` exports the feature id pattern as `FEATURE_ID`. The helper uses it to check the cell before it writes.
- A test fails when the driver pattern differs from `FEATURE_ID`.

## Acceptance Criteria

- [ ] AC-1: Full id in the row
  - Given a chart with a Steps table
  - When the coordinator runs the helper with slug `sample-step`
  - Then the new row holds `0000500-sample-step` in the `Feature id` cell
- [ ] AC-2: Driver accepts the row
  - Given a chart the helper wrote
  - When the test applies the driver pattern to the `Feature id` cell of the parsed row
  - Then the pattern matches
- [ ] AC-3: One pattern
  - Given the exported `FEATURE_ID` and the `FEATURE` constant in `initiative-run.mjs`
  - When the test compares their sources
  - Then the two are identical

## Dependencies

- `initiative-chart.mjs` parses the chart in the test.
