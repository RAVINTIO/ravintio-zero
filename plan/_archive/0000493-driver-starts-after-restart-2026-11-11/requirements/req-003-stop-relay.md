---
title: "Requirement: REQ-003 - Stop relay"
summary: "A block in a handed-over step stops new starts in the successor."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Stop relay

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Source:** US-003
**Priority:** must-have

## User Story

As the coordinator, I want a block in a handed-over step to stop the new driver. The stop rules then still hold.

## Functional Requirements
- After a handoff, the old driver writes the stop line to `plan/.initiative-control/step-{n}/stopped` when a handed-over session blocks or fails. It also prints the line.
- The successor stops new starts when it reads a `stopped` file for an adopted step. It prints `I-C Run: Stopping:` and the stop line.
- A driver that starts with no `--handoff` flag removes stale `stopped` files and ignores them.
- The `stopped` file holds one line, cut to 500 characters, and the driver reads it as data.

## Acceptance Criteria
- [ ] AC-1: The old driver records the stop
  - Given a handed-over step blocks
  - When the old driver reads the block
  - Then it writes the `stopped` file and prints the stop line
- [ ] AC-2: The successor stops new starts
  - Given an adopted step has a `stopped` file
  - When the successor polls the step
  - Then it starts no new step and exits 1 with that stop line after its running steps end
- [ ] AC-3: A stale file never stops a fresh driver
  - Given an old `stopped` file exists
  - When a driver starts with no `--handoff` flag
  - Then it removes the file and starts steps as usual

## Dependencies
- REQ-001 and REQ-002.
