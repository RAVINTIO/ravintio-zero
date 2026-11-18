---
title: "Requirement: REQ-001 - Stable guard input"
summary: "The old-name guard reads input that no earlier suite changes, so a full-suite run and a solo run agree."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Stable guard input

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000561-old-name-guard-fails-in-full-suite
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I run the full suite, so that the old-name guard gives the result it gives alone.

## Functional Requirements
- P2 reproduces the failure first and names the earlier suite or the cause. The build log records it.
- The guard reads a stable copy of the tree, or the earlier suite stops changing the tree. The reproduction decides which.
- The allowlist and the old-name pattern keep their current entries.
- The guard still prints each hit as `path:line`.

## Acceptance Criteria
- [ ] AC-1: the solo and full-suite results agree
  - Given a run of the full suite and a solo run of the guard on the same commit
  - When both runs end
  - Then both report the same pass or fail result for the guard
- [ ] AC-2: the allowlist keeps its entries
  - Given the guard suite before and after the change
  - When a reader compares the `ALLOW_DIRS` and `ALLOW_FILES` lists and `OLD_NAMES`
  - Then each list holds the same entries

## Dependencies
- None
