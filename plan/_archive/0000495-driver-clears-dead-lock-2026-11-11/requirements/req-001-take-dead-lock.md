---
title: "Requirement: REQ-001 - Take a dead lock"
summary: "The driver takes a lock whose process no longer runs and reports it."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Take a dead lock

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I start a driver over a dead lock, so that I need not remove the file by hand.

## Functional Requirements
- When the `wx` write of `plan/.initiative-runner.lock` fails with `EEXIST`, the driver reads the file.
- If the file holds only a decimal pid and that process does not run, the driver prints one line that names the pid.
- The driver then removes the file and writes its own pid with `wx`.
- The check uses the existing `alive(pid)` helper.

## Acceptance Criteria
- [ ] AC-1: dead pid, driver takes the lock
  - Given the lock holds the pid of a process that has exited
  - When the driver starts
  - Then the driver prints a line that names the pid and runs the step
- [ ] AC-2: driver frees the lock at exit
  - Given the driver took a dead lock
  - When the driver exits
  - Then the lock file is gone

## Dependencies
- `alive(pid)` in `initiative-run.mjs` from 0000493.
