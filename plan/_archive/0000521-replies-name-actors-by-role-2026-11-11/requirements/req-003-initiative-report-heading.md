---
title: "Requirement: REQ-003 - Initiative report heading"
summary: "The coordinator report heading reads Decisions for the human."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Initiative report heading

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000521-replies-name-actors-by-role
**Source:** US-003
**Priority:** must-have

## User Story

As the human, I read the heading `Decisions for the human` in a coordinator report, so that the report follows the same rule.

## Functional Requirements
- The initiative skill names the heading `Decisions for the human`.
- The roadmap standards name the same heading.
- The initiative skill sentence on routine fixes names the coordinator and not "you".
- `test-0000450-req-004-report-format.sh` pins the new heading.

## Acceptance Criteria
- [ ] AC-1: the skill and the standards use the new heading
  - Given the initiative skill and the roadmap standards
  - When a test searches them
  - Then each holds `Decisions for the human` and neither holds `Decisions for you`

## Dependencies
- None.
