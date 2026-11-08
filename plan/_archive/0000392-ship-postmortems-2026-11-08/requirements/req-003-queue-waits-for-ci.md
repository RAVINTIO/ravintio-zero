---
title: "Requirement: req-003 - Queue waits for CI"
summary: "Queue waits for CI."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Queue waits for CI

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Source:** US-003
**Priority:** must-have

## User Story

As a coordinator, I want the merge queue to wait for every check on the version commit it pushes, so that GitHub does not refuse the merge.

## Functional Requirements

- After the version push, the queue polls `gh pr checks {pr} --json name,bucket` every 10 seconds.
- An empty list counts as pending until the timeout of 30 minutes.
- The queue merges only when every check has the bucket `pass` or `skipping`.
- A check with the bucket `fail` or `cancel` stops the queue with the check name.
- `MQ_POLL_MS` and `MQ_TIMEOUT_MS` override the poll interval and the timeout.

## Acceptance Criteria

- [ ] AC-1: Pending checks delay the merge
  - Given a stub `gh` that reports a pending check twice after the push
  - When the queue runs
  - Then the queue polls again and merges after the checks pass
- [ ] AC-2: Failed check stops the queue
  - Given a stub `gh` that reports a failed check named `unit-tests` after the push
  - When the queue runs
  - Then the queue exits 1 with `unit-tests` in the message and does not merge

## Dependencies

- None
