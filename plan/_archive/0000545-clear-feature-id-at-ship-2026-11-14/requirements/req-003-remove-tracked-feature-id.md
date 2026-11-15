---
title: "Requirement: REQ-003 - Remove the tracked stale id file"
summary: "The step PR deletes the tracked plan/.feature-id."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Remove the tracked stale id file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Source:** US-003
**Priority:** must-have

## User Story

As the initiative branch, I hold no `plan/.feature-id`, so that the next step starts clean.

## Functional Requirements
- The step PR deletes the tracked `plan/.feature-id`.

## Acceptance Criteria
- [ ] AC-1: The PR head tracks no id file
  - Given the closing push of step 1
  - When `git ls-files plan/.feature-id` runs on the PR head
  - Then it prints nothing

## Dependencies
- None.
