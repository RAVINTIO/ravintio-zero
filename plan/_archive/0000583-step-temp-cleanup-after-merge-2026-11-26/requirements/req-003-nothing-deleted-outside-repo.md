---
title: "Requirement: REQ-003 - The driver deletes nothing outside the repo"
summary: "The driver and the pack scripts never remove a path by name in a shared temp folder."
status: "active"
version: "0.1.1"
---
# Requirement: REQ-003 - The driver deletes nothing outside the repo

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Source:** US-003
**Priority:** must-have

## User Story

As the human on the loop, I want the driver to delete nothing outside the repo, so that a suite never removes another project's files.

## Functional Requirements
- The driver has no function that removes a path by name in a temp folder.
- A test fails any pack script under `scripts/` or `hooks/` that removes a path in `/tmp`, `os.tmpdir()`, or `$TMPDIR`.

## Acceptance Criteria
- [ ] AC-1: A planted file survives
  - Given files named `step1*` and `step2*` in a temp folder outside the repo
  - When the driver runs a step to merge
  - Then every file still exists
- [ ] AC-2: The scan finds no removal
  - Given the pack scripts
  - When the test scans them
  - Then none removes a path in a shared temp folder

## Dependencies
- None.
