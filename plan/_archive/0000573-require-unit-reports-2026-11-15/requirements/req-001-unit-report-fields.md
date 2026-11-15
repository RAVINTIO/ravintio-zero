---
title: "Requirement: REQ-001 - Unit report fields"
summary: "A unit report holds four fields. The orchestrator rejects one that lacks a field and resumes the unit once."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Unit report fields

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000573-require-unit-reports
**Source:** US-001
**Priority:** must-have

## User Story

As an orchestrator, I read a unit report with four fields, so that I log the unit without a rerun.

## Functional Requirements
- `agent-dispatch-standards.md` has a rule anchored `dispatch-unit-report`. The rule names four fields: the RED line, the GREEN line, the commit hash, and any deviation.
- The same rule says the orchestrator rejects a report that lacks a field.
- The rule says the orchestrator resumes the unit once after a rejection. A second bad report takes the unit's normal failure path.
- Both copies of the standard carry the rule: `src/ravintio-zero/standards/` and `ravintio-zero/standards/`.

## Acceptance Criteria
- [ ] AC-1: Four fields
  - Given the dispatch standard
  - When a test reads the `dispatch-unit-report` rule
  - Then the rule names the RED line, the GREEN line, the commit hash, and the deviation
- [ ] AC-2: Reject and resume once
  - Given a unit that returns an empty report
  - When the orchestrator applies the rule
  - Then the rule says it rejects the report and resumes the unit once

## Dependencies
- None.
