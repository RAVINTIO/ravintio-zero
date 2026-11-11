---
title: "Requirement: REQ-002 - Watcher events and chart state"
summary: "The watcher prints events for ready files, queue failures, and driver exits, and reads the chart for merged steps."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Watcher events and chart state

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000450-coordinator-status-view
**Source:** US-002, US-003
**Priority:** must-have

## User Story

As a coordinator, I see an event when a step is ready, the queue fails, or the driver exits. I also see merged steps as merged.

## Functional Requirements
- The watcher reads the chart `Status` column each pass. A step that the chart marks merged is never listed as ready or running, whatever its control files hold.
- When a `ready` file appears for a step the chart lists as pending, the watcher prints `I-C Run: event: step {n} ready PR #{k}` once.
- The ready event also fires when no step has a `running` file.
- When a step log holds a line that starts `I-D Advance: Blocked: queue stopped on step {n}`, the watcher prints it once as `I-C Run: event: ` followed by the line. It prints no event for a merged step.
- When the lock file is present on one pass and gone on the next while the initiative file remains, the watcher prints `I-C Run: event: driver exited` once.
- The heartbeat adds the merged count as `merged {m} of {total}`.

## Acceptance Criteria
- [ ] AC-1: a ready file prints an event
  - Given a step with a new `ready` file and a chart status of pending
  - When the watcher runs a pass
  - Then it prints `event: step {n} ready PR #{k}` once
- [ ] AC-2: a merged step is not ready
  - Given a stale `ready` file for a step the chart marks merged
  - When the watcher runs a pass
  - Then it prints no ready event and no ready heartbeat for that step
- [ ] AC-3: a lock that disappears prints an exit event
  - Given a lock file on pass one and none on pass two
  - When the watcher runs two passes
  - Then it prints `event: driver exited` once

## Dependencies
- REQ-003 writes the queue stop line to the step log.
