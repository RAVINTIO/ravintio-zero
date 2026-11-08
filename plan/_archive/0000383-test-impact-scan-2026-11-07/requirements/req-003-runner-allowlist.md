---
title: "Requirement: req-003 - Runner allowlist"
summary: "Runner allowlist"
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Runner allowlist

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Source:** US-003
**Priority:** must-have

## User Story

As a test author, I get `run-tests.sh` and `run-tests.ps1` listed when a run adds a non-suite file under `ravintio-zero/tests/`, so that the runner does not stop on an undiscovered file.

## Functional Requirements

- The scan names a cause: the run adds a file under `ravintio-zero/tests/` that is not a `test-*.sh` suite.
- The cause lists `run-tests.sh` and `run-tests.ps1` in the unit that adds the file.

## Acceptance Criteria

- [ ] AC-1: Cause named
  - Given the plan skill
  - When a test reads its scan section
  - Then the section names the non-suite file cause and both runner files

## Dependencies

- None
