---
title: "Requirement: REQ-001 - Sibling-copy line"
summary: "The test impact scan says to list the regression copy of each test it names."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Sibling-copy line

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000570-sibling-test-copies-in-impact-scan
**Version:** 0.133.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I list the regression copy of each test I name, so no pinned copy fails the full suite late.

## Functional Requirements
- The `## Test impact scan` section of the plan `SKILL.md` says to grep `ravintio-zero/tests/regression/` for a file with the same name as each listed test.
- The section says to list each match in the execution plan.
- The sentence joins the existing scan paragraph and adds no line.

## Acceptance Criteria
- [ ] AC-1: the scan holds the sibling-copy line
  - Given the `## Test impact scan` section of the plan skill
  - When a test reads the section
  - Then it names `tests/regression/`, says to grep for the same file name, and says to list the match
- [ ] AC-2: the scan stays small
  - Given the scan text of the plan skill and its reference
  - When a test counts it
  - Then the text holds 21 lines or fewer
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the plan skill
  - Then the files are identical

## Dependencies
- None
