---
title: "Requirement: REQ-003 - Name the helper in the docs"
summary: "The ship skill and the roadmap standards tell a step to use the helper."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Name the helper in the docs

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I read one command in the ship skill. Then I write the ready file the same way every time.

## Functional Requirements
- Item 8 of I-D Advance in `roadmap-standards.md` names `initiative-ready.mjs --pr {n}` and describes the driver recovery.
- The ship skill tells a concurrent-driver step to run the helper.
- The component manifest and the architecture overview list the helper.

## Acceptance Criteria
- [ ] AC-1: Docs name the helper
  - Given the ship skill and the roadmap standards
  - When a reader looks for how to write `ready`
  - Then both name `initiative-ready.mjs --pr {n}`

## Dependencies
- REQ-001 and REQ-002.
