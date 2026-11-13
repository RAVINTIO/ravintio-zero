---
title: "Requirement: REQ-007 - Coordinator start-up"
summary: "Both start-up hooks name the initiative skill for a coordinator session."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-007 - Coordinator start-up

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-007
**Priority:** should-have

## User Story

As the human, I see the coordinator session load the initiative skill, so that it never loads the orchestrator.

## Functional Requirements
- `auto-trigger-orchestrator.mjs` and `check-orchestrator-presence.mjs` treat a non-step session as a coordinator in two cases.
- The first case is a draft `plan/roadmap/*/initiative.md` with status `charted`. The second is an `active` initiative.
- Both hooks name the initiative skill for a coordinator.

## Acceptance Criteria
- [ ] AC-1: Charted draft
  - Given a non-step session and a draft chart with status `charted`
  - When either hook runs
  - Then it names the initiative skill
- [ ] AC-2: Active initiative
  - Given a non-step session and an `active` initiative
  - When either hook runs
  - Then it names the initiative skill
- [ ] AC-3: Step session unchanged
  - Given a step session
  - When either hook runs
  - Then it does not name the initiative skill

## Dependencies
- None
