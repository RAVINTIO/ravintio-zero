---
title: "Requirement: REQ-002 - Skill wiring"
summary: "The implement skill and two standards name the script for each marker line."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Skill wiring

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000575-build-log-marker-helper
**Source:** US-002
**Priority:** must-have

## User Story

As the implement skill, I name the script for each RED, GREEN, and Done line, so that sessions use it.

## Functional Requirements
- The rule `implement-inline-unit` tells the session to append each `RED:`, `GREEN:`, and `Done:` line with `build-log-mark.mjs`.
- `workflow-governance-standards.md` and `agent-dispatch-standards.md` name the script next to the marker forms.
- Each edit lands in `src/ravintio-zero/` and in the mirror `ravintio-zero/`.

## Acceptance Criteria
- [ ] AC-1: Skill names the script
  - Given the implement skill
  - When a reader opens the rule `implement-inline-unit`
  - Then the rule names `build-log-mark.mjs` for the three lines
- [ ] AC-2: Standards name the script
  - Given the governance and dispatch standards
  - When a reader looks up the marker forms
  - Then each standard names `build-log-mark.mjs`

## Dependencies
- REQ-001
