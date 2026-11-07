---
title: "Requirement: REQ-003 - closed phase blocks"
summary: "The build log check fails a phase whose End is filled and whose block lacks a Complete line."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - closed phase blocks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I find `build-log-check.mjs` fails a closed phase block with no `Complete:` or `Skipped:` line, so that the watcher and resume read every phase end.

## Functional Requirements
- A phase block counts as closed when its `End` holds a time.
- A closed block must hold a `Complete: P{n}` line in the block. A `Skipped: P{n}` line elsewhere in the log counts for a phase with no block.
- A block still running, with a blank or placeholder `End`, is not checked for the line.
- Each finding names the phase.

## Acceptance Criteria
- [ ] AC-1: open end line fails
  - Given a fixture log with P1 End filled and no `Complete: P1` line
  - When the check runs
  - Then it exits 1 and names P1
- [ ] AC-2: complete log passes
  - Given a fixture log where each closed block holds a `Complete:` line
  - When the check runs
  - Then it reports no Complete finding
- [ ] AC-3: running phase passes
  - Given a fixture log whose last block has a placeholder End
  - When the check runs
  - Then it reports no Complete finding for that block

## Dependencies
- None.
