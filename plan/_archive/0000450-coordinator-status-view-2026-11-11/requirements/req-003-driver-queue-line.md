---
title: "Requirement: REQ-003 - Driver queue failure line"
summary: "The driver prints the queue failure reason when it happens and writes it to the step log."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Driver queue failure line

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I see the queue failure reason when it happens. I then act on it at once.

## Functional Requirements
- When the merge queue fails for a step, the concurrent driver prints `I-D Advance: Blocked: queue stopped on step {n}` and the reason at once.
- The driver appends the same line to `plan/.initiative-logs/step-{n}.log`, so the watcher and the status script read it.
- The line prints once. The stop at exit repeats it as before.
- The driver changes nothing else about which stops it takes.

## Acceptance Criteria
- [ ] AC-1: the reason prints at the failure
  - Given a queue that exits 1 for step 26
  - When the driver handles the failure
  - Then it prints the `queue stopped on step 26` line with the reason before it exits
- [ ] AC-2: the step log holds the line
  - Given the same failure
  - When the driver handles it
  - Then `step-26.log` ends with the same line

## Dependencies
- None.
