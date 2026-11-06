---
title: "Requirement: REQ-005 - Watcher waits for the build log"
summary: "Watcher waits for the build log."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Watcher waits for the build log

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-005
**Priority:** must-have

## User Story

As a coordinator, I want the watcher to print `waiting for the build log` and skip the stale check, and to name the running step, so that I see no false stale line.

## Functional Requirements
- With no `plan/current/build-log.md`, the watcher prints `I-C Run: waiting for the build log` once per absence and prints no stale line.
- The heartbeat names the running step from the newest `step-{n}.log` by modified time, ignoring attempt logs. It falls back to the chart position when no step log exists.

## Acceptance Criteria
- [ ] AC-1: no stale line
  - Given a repo with no `plan/current/build-log.md` and a newer commit than the newest archived log
  - When the watcher runs once
  - Then it prints the waiting line and no stale line
- [ ] AC-2: running step
  - Given the chart position moved to 6 and `step-5.log` is the newest step log
  - When the watcher prints a heartbeat
  - Then it names step 5
