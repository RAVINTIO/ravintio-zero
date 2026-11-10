---
title: "Requirement: REQ-003 - ship check and rules"
summary: "The standards and the pickup step tell a step to read each named item and to run the check before the PR."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - ship check and rules

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Source:** US-003
**Priority:** must-have

## User Story

As a step session, I fail ship when a named item has no commit or report, so that a miss never reaches the PR.

## Functional Requirements
- `roadmap-standards.md` I-C Run rule `icrun-queue` tells the step to run `initiative-queue.mjs list --step {n}` and to read each `item.md`.
- I-D Advance step 2 tells the step to run `initiative-queue.mjs check` before `gh pr create`. A failure stops the PR until the step commits the item or logs `Queue item {name}: {reason}`.
- The orchestrator pickup step in `orchestrator-p0-start-actions.md` names the helper.

## Acceptance Criteria
- [ ] AC-1: read rule
  - Given `roadmap-standards.md`
  - When the test reads rule `icrun-queue`
  - Then it names `initiative-queue.mjs list` and `item.md`
- [ ] AC-2: ship rule
  - Given the I-D Advance section
  - When the test reads step 2
  - Then it names `initiative-queue.mjs check` and the report line
- [ ] AC-3: pickup
  - Given the pickup step
  - When the test reads it
  - Then it names the helper

## Dependencies
- REQ-001
