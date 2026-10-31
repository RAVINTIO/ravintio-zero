---
title: "Requirement: REQ-003 - a suite run keeps every step log"
summary: "a suite run keeps every step log."
status: "active"
version: "0.41.1"
---
# Requirement: REQ-003 - a suite run keeps every step log

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative owner, I want a full suite run to leave the step logs alone, so that the coordinator can read the stop evidence.

## Functional Requirements

- No test moves, renames, or deletes `plan/.initiative-logs/` in the live repo.
- A test lists the folder before and after the guard suites run and compares the listings.

## Acceptance Criteria

- [ ] AC-1: the suites leave the folder unchanged
  - Given a repo with step logs in `plan/.initiative-logs/`
  - When `test-0000042-req-006` and `test-0000043-req-009` run
  - Then the folder listing is the same afterwards
- [ ] AC-2: no test touches the live folder
  - Given every file in `ravintio-zero/tests/`
  - When a test scans for `mv`, `rm`, or `rename` aimed at the live `plan/.initiative-logs`
  - Then it finds none

## Dependencies

REQ-001
