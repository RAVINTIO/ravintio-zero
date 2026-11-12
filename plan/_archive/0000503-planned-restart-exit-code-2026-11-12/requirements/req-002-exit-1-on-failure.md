---
title: "Requirement: REQ-002 - Exit 1 on a failure"
summary: "A real failure keeps exit 1, also when a restart hit came first in the same run."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Exit 1 on a failure

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want a real failure to keep exit 1, so that I still see a failed driver.

## Functional Requirements
- A `Blocked:` stop and a bare `Setup:` stop exit 1.
- A signal stop exits 1.
- In the concurrent path, a later failure after a restart hit drops the planned flag.
- The handoff exit stays 0.

## Acceptance Criteria
- [ ] AC-1: a bare Setup stop exits 1
  - Given a step changes a setup file only, with no approved setup command
  - When the driver stops
  - Then the line starts `I-D Advance: Setup:` and the exit code is 1
- [ ] AC-2: a blocked step exits 1
  - Given a step session prints `Blocked:`
  - When the driver stops
  - Then the exit code is 1
- [ ] AC-3: a failure after a restart hit exits 1
  - Given one step triggers a restart hit and another step then fails in the same run
  - When the driver stops
  - Then the exit code is 1
- [ ] AC-4: a clean run exits 0
  - Given no step changes a watched file
  - When every step merges
  - Then the exit code is 0

## Dependencies
- REQ-001.
