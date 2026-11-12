---
title: "Requirement: REQ-001 - Exit 75 on a restart"
summary: "After a Restart line the driver exits 75, in the serial and the concurrent path."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Exit 75 on a restart

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the driver to exit 75 after a `Restart:` line, so that the host reports no failure.

## Functional Requirements
- A stop class `Restart` extends `Stop` and carries `planned = true`.
- The serial path throws it for `I-D Advance: Restart:` and `I-D Advance: Restart: Setup:`.
- The concurrent path marks its stop as planned when the first stop line starts `I-D Advance: Restart:`.
- `main()` exits 75 when the final stop has `planned = true`.
- The line text does not change.

## Acceptance Criteria
- [ ] AC-1: the serial driver exits 75
  - Given step 1 changes `initiative-run.mjs` and merges
  - When the serial driver finishes step 1
  - Then it prints the `Restart:` line and exits 75
- [ ] AC-2: the concurrent driver exits 75
  - Given a concurrent run where a merged step changes the watcher and no handoff is possible
  - When the running steps end
  - Then the driver prints the `Restart:` line and exits 75
- [ ] AC-3: the combined line exits 75
  - Given a step changes a watched file and a setup file with no approved setup command
  - When the driver stops
  - Then the line starts `I-D Advance: Restart: Setup:` and the exit code is 75

## Dependencies
- `Stop`, `main()`, `setStop()`, and `restartLine()` in `initiative-run.mjs`.
