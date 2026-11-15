---
title: "Requirement: REQ-001 - Size cap lists every cap"
summary: "The Size cap cause asks for every cap that measures the skill and plans growth against the lowest."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Size cap lists every cap

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000567-test-impact-size-caps-and-frozen-lines
**Version:** 0.125.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I list every cap test with its value, so that I plan against the lowest cap.

## Functional Requirements
- The `Size cap` cause says to list every test that measures the skill, not the first match.
- The cause says to list each cap value.
- The cause says to plan the unit's growth against the lowest cap.

## Acceptance Criteria
- [ ] AC-1: every cap named
  - Given the reference file
  - When a reader looks at the `Size cap` cause
  - Then it says to list every test that measures the skill with each cap value
- [ ] AC-2: lowest cap named
  - Given the cause
  - When a run grows the skill
  - Then the cause says to plan against the lowest cap
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
