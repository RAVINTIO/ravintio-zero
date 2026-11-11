---
title: "Requirement: REQ-003 - Document the dead-lock rule"
summary: "The driver header and the roadmap standards state when the driver takes a lock."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Document the dead-lock rule

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000495-driver-clears-dead-lock
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I read when the driver takes a lock, so that I know when to remove a lock by hand.

## Functional Requirements
- The header comment of `initiative-run.mjs` states the dead-lock rule in step 2.
- `roadmap-standards.md` states the rule where it lists the driver lock.
- Both texts say that a live pid, an unreadable lock, and a symlink still refuse.

## Acceptance Criteria
- [ ] AC-1: both texts state the rule
  - Given the change is complete
  - When a reader opens the driver header and the standards
  - Then each text says the driver takes a lock whose process no longer runs

## Dependencies
- REQ-001 and REQ-002 define the rule.
