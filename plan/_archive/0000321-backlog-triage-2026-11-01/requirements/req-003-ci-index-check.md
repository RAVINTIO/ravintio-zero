---
title: "Requirement: REQ-003 - CI index check"
summary: "CI fails when the committed index is stale."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - CI index check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I read `plan/backlog/index.md`, so that I see every open entry with its priority and theme at a glance.

## Functional Requirements
- `.github/workflows/ravintio.yml` runs `node ravintio-zero/scripts/backlog-index.mjs --check` as a step.
- `ravintio-zero/hooks/ravintio.yml`, the pack copy, runs the same step.
- Setup does not overwrite the tracked workflow, so this step edits both files.

## Acceptance Criteria
- [ ] AC-1: both workflows run the check
  - Given the tracked workflow and the pack copy
  - When a test reads each
  - Then each runs `backlog-index.mjs --check`

## Dependencies
REQ-002
