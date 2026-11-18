---
title: "Requirement: REQ-002 - Reference wiring"
summary: "The Phase Invocation reference names the Start-time check."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Reference wiring

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000576-phase-start-time-at-phase-start
**Source:** US-002
**Priority:** must-have

## User Story

As the orchestrator, I name the check in the Phase Invocation reference, so that sessions know to write the block first.

## Functional Requirements
- `orchestrator-phase-invocation.md` holds a new rule-anchored bullet that names `build-log-check.mjs` and says it fails a `Start` later than the phase's first artifact commit.
- Both pack trees hold the same text.

## Acceptance Criteria
- [ ] AC-1: the reference names the check
  - Given the Phase Invocation reference in each pack tree
  - When a test greps it
  - Then it holds the new bullet with `build-log-check.mjs` and `Start`

## Dependencies
- REQ-001 supplies the check that the bullet names.
