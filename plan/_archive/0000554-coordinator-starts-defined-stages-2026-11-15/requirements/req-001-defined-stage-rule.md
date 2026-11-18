---
title: "Requirement: REQ-001 - Defined-stage rule"
summary: "The coordinator starts a defined next stage and reports it as a status."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Defined-stage rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000554-coordinator-starts-defined-stages
**Source:** US-001
**Priority:** must-have

## User Story

As the human on the loop, I read a status when the coordinator starts a defined stage. I then answer no question whose answer is always yes.

## Functional Requirements
- `roadmap-standards.md` holds rule `coord-defined-stage` in its coordinator questions.
- The rule says the coordinator starts a stage the pipeline defines as next and reports the start as a status.
- The rule says the coordinator asks only at a real fork or before a human-only action such as a merge into `main`.
- The initiative skill says that I-E Delivery starts with no question after the driver's clean end.

## Acceptance Criteria
- [ ] AC-1: Standards hold the rule
  - Given the roadmap standards
  - When a reader looks for rule `coord-defined-stage`
  - Then the rule names a defined next stage, a status report, a real fork, and a human-only action
- [ ] AC-2: Skill starts delivery without a question
  - Given the initiative skill
  - When the driver has ended cleanly
  - Then the skill says I-E Delivery starts with no question

## Dependencies
- Rule `coord-question-form`, which the new rule qualifies.
