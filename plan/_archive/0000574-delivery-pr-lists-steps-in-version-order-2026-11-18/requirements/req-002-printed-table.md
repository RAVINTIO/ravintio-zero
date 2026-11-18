---
title: "Requirement: REQ-002 - The script prints the step table"
summary: "reshape-initiative.mjs prints a table of step, title, version, and tag in replay order."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The script prints the step table

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000574-delivery-pr-lists-steps-in-version-order
**Version:** 0.143.0
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I get the step table from `reshape-initiative.mjs` in replay order. I then paste it without sorting by hand.

## Functional Requirements
- After the `wrote` lines, the script prints a markdown table with the columns `Step`, `Title`, `Version`, and `Tag`.
- Each row is one chart step, in replay order.
- `Step` holds the chart step number. `Version` holds the version without the `v`.
- The script prints the table before the history check output.
- A failure before the replay prints no table.

## Acceptance Criteria
- [ ] AC-1: the table has the four columns
  - Given a chart with two merged steps
  - When the script runs
  - Then the output holds a header row with Step, Title, Version, and Tag
- [ ] AC-2: each row names its step
  - Given the same run
  - When a test reads the rows
  - Then each row holds the chart step number, the title, the version, and the tag
- [ ] AC-3: a failed run prints no table
  - Given a chart step with no tag
  - When the script runs
  - Then it exits 1 and the output holds no table

## Dependencies
- None
