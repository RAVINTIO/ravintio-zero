---
title: "Requirement: req-005 - Repo tests"
summary: "Repo tests"
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - Repo tests

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Source:** US-005
**Priority:** must-have

## User Story

As a developer using Zero, I get my own test folders scanned, so that a changed string lists the repo test that asserts it.

## Functional Requirements

- The scan greps the repo's own test folders as well as `ravintio-zero/tests/`.
- It takes the folders from the stack declaration, or from `tests/`, `test/`, and `__tests__/`.
- The test-writer, refactor, and validate skills name the repo's test folders where they name `ravintio-zero/tests/`.

## Acceptance Criteria

- [ ] AC-1: Scan covers repo tests
  - Given the plan skill
  - When a test reads its scan section
  - Then the section names the repo test folders and the common folder names
- [ ] AC-2: Pack matches still listed
  - Given the plan skill
  - When a test reads its scan section
  - Then the section still names `ravintio-zero/tests/`
- [ ] AC-3: Other skills updated
  - Given the test-writer, refactor, and validate skills
  - When a test reads them
  - Then each names the repo test folders or the stack test command

## Dependencies

- None
