---
title: "Requirement: req-004 - Fixture-pinned lines"
summary: "Fixture-pinned lines"
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - Fixture-pinned lines

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Source:** US-004
**Priority:** must-have

## User Story

As a pack maintainer, I get fixture-pinned lines listed when a run edits an existing pack line, so that P2 runs the named suites before the full suite.

## Functional Requirements

- The scan names a cause: the run edits an existing line in a pack file that a fixture under `ravintio-zero/tests/fixtures/` holds.
- The cause greps the fixture for the line.
- `ravintio-implement` tells P2 to run the suites the plan names before the full suite.

## Acceptance Criteria

- [ ] AC-1: Cause named
  - Given the plan skill
  - When a test reads its scan section
  - Then the section names the fixture cause and the fixtures folder
- [ ] AC-2: P2 runs named suites first
  - Given the implement skill
  - When a test reads it
  - Then it tells P2 to run the suites listed under `## Test impact` before the full suite

## Dependencies

- None
