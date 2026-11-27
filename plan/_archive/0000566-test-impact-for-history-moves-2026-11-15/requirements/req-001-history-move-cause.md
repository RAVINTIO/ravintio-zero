---
title: "Requirement: REQ-001 - History move cause"
summary: "The scan lists every suite with a plan/_archive/ exclusion when a run moves archived content into a live folder."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - History move cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000566-test-impact-for-history-moves
**Version:** 0.124.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I see a `History move` cause, so that I list every suite with a `plan/_archive/` exclusion under `## Test impact`.

## Functional Requirements
- The reference file holds a `History move` cause.
- The cause fires when the run moves or copies archived content into a live folder.
- The cause names the grep of `ravintio-zero/tests/` for `plan/_archive/`.
- The cause says to list each match under `## Test impact`.

## Acceptance Criteria
- [ ] AC-1: cause named
  - Given the reference file
  - When a reader looks for the cause
  - Then it reads `History move`
- [ ] AC-2: grep and listing named
  - Given the cause
  - When a run moves archived content into a live folder
  - Then the cause names `plan/_archive/` as the grep target
  - And it says to list each match
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
