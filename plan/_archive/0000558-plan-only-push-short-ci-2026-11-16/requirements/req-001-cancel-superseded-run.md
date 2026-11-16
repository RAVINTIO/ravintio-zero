---
title: "Requirement: REQ-001 - cancel a superseded run"
summary: "A newer push to a pull request cancels the older run of the same pull request."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - cancel a superseded run

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000558-plan-only-push-short-ci
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I want CI to cancel an older run on a newer push, so that only the newest head uses runners.

## Functional Requirements
- The workflow holds a top-level `concurrency` block.
- The group key holds the workflow name and the pull request number, or the commit for a push. A push run never shares a group.
- Only a `pull_request` event cancels an older run.
- A push to `main` or `master` never cancels an older run.
- A `closed` event uses a group of its own.

## Acceptance Criteria
- [ ] AC-1: Pull request runs cancel
  - Given the workflow file
  - When a reader parses its top-level `concurrency` block
  - Then `cancel-in-progress` is true for a `pull_request` event
- [ ] AC-2: Push runs never cancel
  - Given the workflow file
  - When a reader parses its `cancel-in-progress` expression
  - Then the expression is false for a `push` event, and the group holds the commit
- [ ] AC-3: A closed event has its own group
  - Given the workflow file
  - When a reader parses its `group` expression
  - Then the expression holds `github.event.action == 'closed'`

## Dependencies
- None.
