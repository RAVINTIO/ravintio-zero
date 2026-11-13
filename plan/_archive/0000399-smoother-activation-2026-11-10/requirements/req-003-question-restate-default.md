---
title: "Requirement: REQ-003 - Restate and default"
summary: "The initiative skill restates the request as one plan, names a default, and asks Go."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-003 - Restate and default

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-003
**Priority:** must-have

## User Story

As the human, I see my request restated as one plan with a default, so that I answer "Go?".

## Functional Requirements
- The initiative skill tells the coordinator to restate the human's words as one concrete plan.
- It names the default and asks "Go?".
- It offers other options only on a real fork.

## Acceptance Criteria
- [ ] AC-1: Restate, default, and confirm
  - Given the initiative skill text
  - When a skill test reads it
  - Then it names the restate, default, and "Go?" form
- [ ] AC-2: Options only on a fork
  - Given the initiative skill text
  - When a skill test reads it
  - Then it limits other options to a real fork

## Dependencies
- REQ-004 shares the skill edit in unit U-003
