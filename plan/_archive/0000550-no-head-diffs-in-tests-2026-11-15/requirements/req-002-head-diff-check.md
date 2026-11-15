---
title: "Requirement: REQ-002 - HEAD diff style check"
summary: "A suite fails any test file that runs git diff against HEAD or a moving ref."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - HEAD diff style check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000550-no-head-diffs-in-tests
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I run a suite that fails any suite diffing against `HEAD`, so that a vacuous test cannot merge.

## Functional Requirements
- The suite `test-0000550-req-002-no-head-diffs.sh` scans every suite under `ravintio-zero/tests/`.
- It flags a `git diff` command that names `HEAD`, `HEAD~n`, `HEAD^`, `@`, or `ORIG_HEAD`.
- It skips itself and builds its own pattern from parts.
- It plants a file with such a diff and expects the scan to flag it.

## Acceptance Criteria
- [ ] AC-1: Clean tree passes
  - Given the current suites
  - When the check scans them
  - Then it lists no offender.
- [ ] AC-2: Planted diff fails
  - Given a temporary folder with a suite that runs a diff against `HEAD`
  - When the check scans that folder
  - Then it lists the planted file.

## Dependencies
- REQ-001 names the rule that this check enforces.
