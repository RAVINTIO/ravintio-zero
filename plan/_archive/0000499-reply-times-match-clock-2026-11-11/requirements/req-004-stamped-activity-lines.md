---
title: "Requirement: REQ-004 - Stamped activity lines"
summary: "The watcher starts each activity line with its own time."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Stamped activity lines

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000499-reply-times-match-clock
**Source:** US-004
**Priority:** must-have

## User Story

As the human, I see the watcher's own time on each activity line, so that the feed stays right when an agent's time is wrong.

## Functional Requirements
- `initiative-watch.mjs` starts each `I-C Run: activity:` line with `hh:mm ` from its own local clock at print time. Feature 0000388 added this stamp to every watcher line. This step pins it for activity lines.
- The text of the line keeps its 200 character cut. The stamp adds 6 characters.
- `RAVINTIO_REPLY_CLOCK` (hh:mm) replaces the clock for tests.
- Other watcher lines stay as they are.

## Acceptance Criteria
- [ ] AC-1: an activity line carries the time
  - Given a step log with one tool event and `RAVINTIO_REPLY_CLOCK` set to `09:15`
  - When the watcher prints the line
  - Then it starts `09:15 I-C Run: activity:`
- [ ] AC-2: the cap holds
  - Given a tool event with a very long argument
  - When the watcher prints the line
  - Then the text keeps 200 characters and the stamp adds 6

## Dependencies
- 0000240 for the activity lines.
