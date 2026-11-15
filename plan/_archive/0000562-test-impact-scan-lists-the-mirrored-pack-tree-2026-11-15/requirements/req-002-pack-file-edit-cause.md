---
title: "Requirement: REQ-002 - Pack file edit cause"
summary: "The scan lists the handoff suite when a run edits a pack file."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Pack file edit cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000562-test-impact-scan-lists-the-mirrored-pack-tree
**Source:** US-002
**Priority:** must-have

## User Story

As a plan author, I see a `Pack file edit` cause that lists `test-0000493-req-004-handoff-text.sh`, so that I plan the mirrored edit in the same unit.

## Functional Requirements
- The reference file holds a `Pack file edit` cause.
- The cause fires when the run edits a pack file and names `test-0000493-req-004-handoff-text.sh`.
- The cause says the same unit edits both `src/ravintio-zero/` and `ravintio-zero/`.

## Acceptance Criteria
- [ ] AC-1: cause named
  - Given the reference file
  - When a reader looks for the cause
  - Then it reads `Pack file edit` and names the handoff suite
- [ ] AC-2: mirrored edit
  - Given the cause
  - When a unit edits a pack file
  - Then the cause tells the unit to edit both trees

## Dependencies
- REQ-001
