---
title: "Requirement: REQ-004 - req-007 checks the rule file"
summary: "req-007 checks the rule file."
status: "active"
version: "0.41.2"
---
# Requirement: REQ-004 - req-007 checks the rule file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Source:** US-003
**Priority:** must-have

## User Story

As a developer with a generated `CLAUDE.md`, I run the suite and `test-0000164-req-007` passes.

## Functional Requirements

- `test-0000164-req-007-gate-write-doc-correction.sh` no longer lists `CLAUDE.md`.
- It checks `hook-enforcement.md`, `pipeline-reference.md`, and `project-operations.md`.
- It fails when the rule phrases leave `hook-enforcement.md`.

## Acceptance Criteria

- [ ] AC-1: a generated CLAUDE.md does not matter
  - Given a generated `CLAUDE.md` of any content
  - When the test runs
  - Then it passes
- [ ] AC-2: removed phrases fail
  - Given a copy of `hook-enforcement.md` without the three phrases
  - When the check runs on the copy
  - Then it exits 1

## Dependencies

none
