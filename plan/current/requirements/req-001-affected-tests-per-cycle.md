---
title: "Requirement: req-001 - Affected tests per cycle"
summary: "Each cycle runs the affected tests and P2 runs the full suite once."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Affected tests per cycle

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Source:** US-001
**Priority:** must-have

## User Story

As a developer, I want each TDD cycle to run only the tests the unit can affect, so that P2 spends less time on suite runs.

## Functional Requirements

- `ravintio-implement` states the affected-tests rule: each cycle runs the new test and the tests that cover the changed files.
- `ravintio-implement` requires one full suite run before P2 completes, started in the background while docs are written.
- `ravintio-refactor` runs the affected tests in each cycle and leaves the full run to `ravintio-implement`.
- The build log gains a `Tests run: REQ-{nnn}: {files}` line for each cycle.

## Acceptance Criteria

- [ ] AC-1: Affected-tests rule named
  - Given the implement skill
  - When a reader looks for the cycle test scope
  - Then it names the new test and the tests that cover changed files
- [ ] AC-2: One full run before P2 completes
  - Given the implement skill
  - When a reader looks for the full suite rule
  - Then it requires one full suite run before P2 completes
- [ ] AC-3: Tests run line recorded
  - Given the build log template
  - When a cycle ends
  - Then the template shows a `Tests run:` line for it

## Dependencies

- None
