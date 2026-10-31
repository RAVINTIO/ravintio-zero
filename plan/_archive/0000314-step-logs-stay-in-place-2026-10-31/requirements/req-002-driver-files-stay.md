---
title: "Requirement: REQ-002 - driver files stay in place"
summary: "driver files stay in place."
status: "active"
version: "0.41.1"
---
# Requirement: REQ-002 - driver files stay in place

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want the orchestrator and initiative skills to name the driver files a step must leave alone, so that the watcher, the driver, and the coordinator keep their evidence.

## Functional Requirements

- The orchestrator skill gets one sentence in its initiative note: a step session never moves, renames, or deletes `plan/.initiative-logs/`, `plan/.initiative-runner.lock`, or `plan/.initiative-queue/`.
- The initiative skill gets the same rule in its hard limits.
- `roadmap-standards.md` names the rule under `#### Sessions and ack files`.

## Acceptance Criteria

- [ ] AC-1: both skills name the driver files
  - Given the orchestrator and initiative skills
  - When a test reads their text
  - Then each names the three driver files and says a step never moves, renames, or deletes them
- [ ] AC-2: the standards name the rule
  - Given `roadmap-standards.md`
  - When a test reads `#### Sessions and ack files`
  - Then it names the same three files
- [ ] AC-3: size caps hold
  - Given the edited skills
  - When the size tests run
  - Then the initiative skill has fewer than 120 lines and all skill text is 1720 lines or fewer

## Dependencies

REQ-001 for the wording of the guard
