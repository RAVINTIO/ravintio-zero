---
title: "Requirement: REQ-002 - Print the one action left"
summary: "The block ends with the one action the human must take, or none."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Print the one action left

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Source:** US-002
**Priority:** must-have

## User Story

As the human, I want the block to end with my one action, or "none", so I know at once whether to act.

## Functional Requirements
- The driver prints `I-C Run: Summary: action for the human: {action}` as the last line of the block, before the final line of the run.
- If the run ends with no stop and delivery is complete, the action is `none`.
- If the run printed `I-E Delivery: Pending:`, the action is `run initiative delivery from the initiative skill`.
- If the stop line starts `I-D Advance: Restart:`, the action is `start a new driver`.
- If the stop line starts `I-D Advance: Setup:`, the action is `run the setup command in the stop line, then start a new driver`.
- For every other stop, the action is `read the stop line and the step log, then start a new driver`.
- The summary changes no exit code. A planned restart still exits 75 and a failure still exits 1.

## Acceptance Criteria
- [ ] AC-1: clean end
  - Given every step merges
  - When the run ends
  - Then the last block line reads `action for the human: none` or the delivery action
- [ ] AC-2: blocked step
  - Given a step prints `Blocked:`
  - When the run ends
  - Then the action line says to read the stop line and the step log, and the exit code is 1
- [ ] AC-3: planned restart
  - Given a merge changes driver files
  - When the old driver ends
  - Then the action line says to start a new driver, and the exit code is 75

## Dependencies
- REQ-001 and the stop classes `Stop` and `Restart`.
