---
title: "Requirement: REQ-001 - Diff reader cause"
summary: "The test impact scan says to name a test world for add, rename, and delete when a unit reads a git diff."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Diff reader cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000577-plan-lists-change-shapes
**Version:** 0.137.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I name a test world for add, rename, and delete when a unit reads a git diff. The suite then fails before the unit runs on real data.

## Functional Requirements
- `skills/ravintio-plan/references/test-impact-causes.md` holds a `Diff reader` cause.
- The cause covers a unit that reads a git diff or a file list.
- The cause says to name a test world for each of add, rename, and delete.
- The cause says git lists a rename apart from an add, so a world that adds every file as new misses it.
- The `New test file` and `Non-suite file` causes share one line, so the scan stays at 21 lines.

## Acceptance Criteria
- [ ] AC-1: the cause holds the change shape wording
  - Given the `Diff reader` cause of the reference file
  - When a test reads the cause
  - Then it names a git diff, a file list, add, rename, delete, and says to name a test world for each
- [ ] AC-2: the scan stays small and both earlier causes remain
  - Given the scan text of the plan skill and its reference
  - When a test counts it and looks for the merged causes
  - Then the text holds 21 lines or fewer and still names `New test file` and `Non-suite file`
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
