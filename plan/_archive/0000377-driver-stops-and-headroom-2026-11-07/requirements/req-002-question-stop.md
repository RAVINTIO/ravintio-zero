---
title: "Requirement: REQ-002 - Question stop"
summary: "The driver and watcher stop on an open Question line."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Question stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I see the driver stop at once on an unresolved `Question:` line, so that no step guesses an answer only I can give.

## Functional Requirements
- The driver treats a `Question:` line with no later `Resolved:` line like `Blocked:`. It stops with no resume and repeats the line.
- The watcher reports an open `Question:` line.
- The continue prompt names `Question:` as a valid place to end a turn.

## Acceptance Criteria
- [ ] AC-4: Driver stops
  - Given a build log that ends on an open `Question:` line
  - When the step exits 0 without merging
  - Then the driver exits 1 with no resume and prints the question
- [ ] AC-5: Resolved clears it
  - Given a `Question:` line followed by a `Resolved:` line
  - When the step exits 0 without merging
  - Then the driver resumes as before
- [ ] AC-6: Watcher and prompt
  - Given an open `Question:` line and the continue prompt
  - When the watcher reads the build log
  - Then it prints the line, and the prompt text names `Question:`

## Dependencies
- REQ-001 (the chart orders the skill move first).
