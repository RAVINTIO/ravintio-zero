---
title: "Requirement: REQ-002 - Early-end rule"
summary: "Early-end rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Early-end rule

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000354-steps-run-to-the-end
**Version:** 0.52.0
**Source:** US-002
**Priority:** must-have

## User Story

As a step session, I read that I never end my turn before `I-D Advance: Complete:` or a `Blocked:` line, so that I keep going.

## Functional Requirements
- `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` states that a step session never ends its turn before `I-D Advance: Complete:` or a `Blocked:` line.
- The orchestrator skill stays within its byte cap and the skill text total stays within its line cap.

## Acceptance Criteria
- [ ] AC-1: rule present
  - Given the orchestrator skill
  - When a test reads it
  - Then it names `I-D Advance: Complete:` and `Blocked:` as the only ways a step session ends its turn
- [ ] AC-2: caps hold
  - Given the edited skill
  - When the size tests run
  - Then they pass
