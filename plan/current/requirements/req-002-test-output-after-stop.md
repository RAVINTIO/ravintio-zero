---
title: "Requirement: REQ-002 - Test output after a stop"
summary: "The initiative skill reads step test output only after a stop."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Test output after a stop

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000553-coordinator-oversight-not-micromanagement
**Version:** 0.119.0
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I read step test output only after a stop, so that I skip checks the step already runs.

## Functional Requirements
- The skill states that the coordinator reads step test output only after a stop.
- The skill stays under 120 lines.

## Acceptance Criteria
- [ ] AC-1: Test output waits for a stop
  - Given the initiative skill text
  - When the test reads it
  - Then it says the coordinator reads step test output only after a stop
- [ ] AC-2: The skill stays within its cap
  - Given the edited skill
  - When the test counts its lines
  - Then the count is below 120

## Dependencies
- REQ-001
