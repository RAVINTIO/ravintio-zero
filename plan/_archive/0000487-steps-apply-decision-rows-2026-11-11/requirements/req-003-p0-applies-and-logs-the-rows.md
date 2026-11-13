---
title: "Requirement: REQ-003 - P0 applies and logs the rows"
summary: "The P0 start actions and the roadmap standards tell a step to list its rows and log each one."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - P0 applies and logs the rows

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I see one build log line for each applicable row, so that I know the step applied it.

## Functional Requirements
- `orchestrator-p0-start-actions.md` gains a start action with rule anchor `p0-start-decisions`. It runs `decision-rows.mjs list --step {n}` in an initiative step.
- The action logs `Decision applied (initiative chart): {fork}` for each row, or `Decision not applicable (initiative chart): {fork}: {reason}`. With no row it logs `Decisions: none name step {n}`.
- The action says to apply each answer before any step that the answer changes, such as the baseline run.
- `roadmap-standards.md` rule `icrun-decision-row` names the lookup and the check, and the same rule describes the check.

## Acceptance Criteria
- [ ] AC-1: the start action exists
  - Given the P0 start actions file
  - When a test reads it
  - Then it holds the anchor, the command, and both log lines
- [ ] AC-2: the standards describe the check
  - Given `roadmap-standards.md`
  - When a test reads rule `icrun-decision-row`
  - Then it names `decision-rows.mjs` and `build-log-check.mjs`

## Dependencies
- REQ-001, REQ-002.
