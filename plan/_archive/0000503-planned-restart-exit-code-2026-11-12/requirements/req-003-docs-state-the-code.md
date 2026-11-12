---
title: "Requirement: REQ-003 - Docs state the code"
summary: "The driver header, the standards, the initiative skill, and an ADR state that exit 75 is a planned stop."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Docs state the code

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000503-planned-restart-exit-code
**Source:** US-003
**Priority:** must-have

## User Story

As the coordinator, I want the docs to name exit 75 as a planned stop, so that I treat it as one.

## Functional Requirements
- The header comment of `initiative-run.mjs` names exit 75 for a `Restart:` stop.
- The `#### Restart stop` section of `roadmap-standards.md` states exit 75 in place of exit 1.
- The initiative skill says exit 75 is a planned stop and any other non-zero exit is a failure.
- ADR-0327 records the decision, and `docs/decisions-index.md` lists it.
- The skill stays under 120 lines, and both pack trees hold the same text.

## Acceptance Criteria
- [ ] AC-1: the standards name the code
  - Given `roadmap-standards.md`
  - When a reader opens the `Restart stop` section
  - Then it says the driver exits 75
- [ ] AC-2: the skill names the code
  - Given the initiative skill
  - When a reader opens `## Stops`
  - Then it says exit 75 is a planned stop
- [ ] AC-3: the trees match
  - Given the edits
  - When `sync-installed.mjs --check` runs
  - Then it exits 0

## Dependencies
- REQ-001 and REQ-002.
