---
title: "Requirement: REQ-002 - Clean-end action text"
summary: "The clean-end summary no longer names delivery as the human's action."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Clean-end action text

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000554-coordinator-starts-defined-stages
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I read `action for the human: none, the coordinator runs I-E Delivery` after a clean end. The summary then does not name delivery as my action.

## Functional Requirements
- `humanAction` in `initiative-run.mjs` returns `none, the coordinator runs I-E Delivery` when delivery is pending.
- Rule `driver-stop-summary` and the driver header comment name the same text.
- Every other action text stays as it is.

## Acceptance Criteria
- [ ] AC-1: Pending delivery names the coordinator
  - Given a run that ends cleanly with delivery pending
  - When the driver prints its summary
  - Then the action line reads `none, the coordinator runs I-E Delivery`
- [ ] AC-2: Other actions stay
  - Given a run that stops on a `Restart:`, a `Setup:`, or another stop
  - When the driver prints its summary
  - Then the action line keeps its earlier text

## Dependencies
- Test `test-0000511-req-001-003-stop-summary.sh`, which pins the old text.
