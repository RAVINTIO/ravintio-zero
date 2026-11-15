---
title: "Requirement: REQ-001 - Ship deletes the feature id file"
summary: "Ship Step 8 deletes plan/.feature-id with the other sentinels."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Ship deletes the feature id file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000545-clear-feature-id-at-ship
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I leave no `plan/.feature-id` in the step PR, so that the base merge never conflicts on it.

## Functional Requirements
- Ship Step 8 deletes `plan/.feature-id` with the other sentinels.
- Step 8 names the file in its text.

## Acceptance Criteria
- [ ] AC-1: Step 8 names the file
  - Given the ship skill
  - When a reader opens Step 8
  - Then the text names `plan/.feature-id` for deletion
- [ ] AC-2: A scripted Step 8 leaves no tracked id file
  - Given a repo that tracks `plan/.feature-id`
  - When Step 8 runs its deletions and commit
  - Then `git ls-files` lists no `plan/.feature-id`

## Dependencies
- None.
