---
title: "Requirement: REQ-005 - Chart format migration"
summary: "A step that changes a chart format updates the active initiative.md."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Chart format migration

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000351-step-titles-and-history-shape
**Source:** US-005
**Priority:** should-have

## User Story

As a step author, I update the active `initiative.md` when my step changes a chart format, so that no later step stops on the old format.

## Functional Requirements
- The plan skill tells a step that changes a chart format to update `plan/current-initiative/initiative.md` in the same step.
- If the step can't convert a record, it files a backlog entry and names the record in its PR.
- `roadmap-standards.md` states the same rule.

## Acceptance Criteria
- [ ] AC-1: plan skill carries the rule
  - Given the plan skill
  - When a step changes a chart format
  - Then the skill says to update the active `initiative.md` and to file an entry for a record it can't convert
- [ ] AC-2: the active chart has the table
  - Given a step that adds a chart table or column
  - When the step ships
  - Then the active `initiative.md` holds it

## Dependencies
- None.
