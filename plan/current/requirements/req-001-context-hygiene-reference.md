---
title: "Requirement: REQ-001 - Context Hygiene reference"
summary: "Move the Context Hygiene section out of the orchestrator skill."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Context Hygiene reference

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I move Context Hygiene out of the orchestrator `SKILL.md`, so that later steps can add rules under the 9000 byte cap.

## Functional Requirements
- `references/orchestrator-context-hygiene.md` holds the Context Hygiene text unchanged.
- `SKILL.md` has a Pack Index row for the new file and no Context Hygiene section.
- The cap tests and the base fixture check keep passing.

## Acceptance Criteria
- [ ] AC-1: Skill is smaller
  - Given the orchestrator `SKILL.md` after the move
  - When `wc -c` counts its bytes
  - Then the count is 8700 or fewer
- [ ] AC-2: Reference holds the text
  - Given the new reference file
  - When the test greps the old Context Hygiene lines
  - Then each line is in the reference file and `SKILL.md` has no `## Context Hygiene` heading
- [ ] AC-3: Pack Index points to it
  - Given the Pack Index in `SKILL.md`
  - When the test reads its rows
  - Then a row names `references/orchestrator-context-hygiene.md`

## Dependencies
- None.
