---
title: "Requirement: REQ-006 - Chart sets CI fixes"
summary: "Chart sets CI fixes."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - Chart sets CI fixes

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-006
**Priority:** must-have

## User Story

As a chart author, I want a `**Step CI fixes:**` field, so that a step knows whether it may fix its own CI failure.

## Functional Requirements
- `ravintio-zero/templates/initiative.template.md` holds `**Step CI fixes:** stop`, with the values `allowed` and `stop` and the default `stop`.
- `ravintio-zero/standards/roadmap-standards.md` states the rule at I-D Advance step 4: with `stop`, a CI failure on the step PR stops the step. With `allowed`, the step may push a fix inside its own scope and wait again.
- This initiative's chart already holds the field.

## Acceptance Criteria
- [ ] AC-1: template field
  - Given the chart template
  - When a test reads it
  - Then it holds `**Step CI fixes:**` with `allowed` and `stop`
- [ ] AC-2: rule text
  - Given the standards
  - When a test reads I-D Advance
  - Then it states both values and the default
