---
title: "Requirement: REQ-004 - One question per reply"
summary: "The initiative skill allows at most one question per reply and none about stated facts."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-004 - One question per reply

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-004
**Priority:** must-have

## User Story

As the human, I ask at most one question per reply and none about what I already said, so that decisions are quick.

## Functional Requirements
- The initiative skill limits each reply to at most one question.
- It forbids asking what the human already stated.

## Acceptance Criteria
- [ ] AC-1: At most one question
  - Given the initiative skill text
  - When a skill test reads it
  - Then it states at most one question per reply
- [ ] AC-2: No repeated questions
  - Given the initiative skill text
  - When a skill test reads it
  - Then it forbids asking what the human already stated

## Dependencies
- REQ-003 shares the skill edit in unit U-003
