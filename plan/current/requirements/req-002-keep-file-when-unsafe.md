---
title: "Requirement: REQ-002 - Keep the file when unsafe"
summary: "The driver keeps a merged step's ready file when a session runs or the removal fails, and reports why."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Keep the file when unsafe

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the driver to leave a live session alone, so that a running step loses no state.

## Functional Requirements
- If the `running` file of a merged step names a live pid, the driver keeps the `ready` file and prints `I-C Run: Kept: step {n} a session still runs`.
- If the removal fails, or the control path holds a symlink, the driver keeps the file and prints `I-C Run: Kept: step {n} {reason}`.
- A kept file never stops the run.
- Each line is 200 characters or fewer.

## Acceptance Criteria
- [ ] AC-1: live session keeps the file
  - Given the chart marks step 1 merged and its `running` file names a live pid
  - When the driver starts
  - Then the `ready` file remains and the driver prints a `Kept:` line
- [ ] AC-2: failure keeps the file and the run goes on
  - Given the control path of a merged step is a symlink
  - When the driver starts
  - Then the driver prints a `Kept:` line, removes nothing through the link, and does not stop
- [ ] AC-3: dead pid does not keep the file
  - Given the `running` file of a merged step names a pid that no longer runs
  - When the driver starts
  - Then the driver removes the `ready` file

## Dependencies
- REQ-001, `runningPid()` and `alive()` in `initiative-run.mjs`.
