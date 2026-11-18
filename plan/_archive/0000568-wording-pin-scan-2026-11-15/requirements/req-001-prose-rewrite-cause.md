---
title: "Requirement: REQ-001 - Prose rewrite cause"
summary: "The test impact scan has a Prose rewrite cause that greps the tests for each changed sentence."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Prose rewrite cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000568-wording-pin-scan
**Version:** 0.129.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I grep the tests for each changed sentence, so that I list every wording pin under `## Test impact`.

## Functional Requirements
- The reference file has a `Prose rewrite` cause.
- The cause says to grep `ravintio-zero/tests/` for each changed sentence.
- The cause says to list the matches in the execution plan.

## Acceptance Criteria
- [ ] AC-1: the cause greps and lists
  - Given the reference file
  - When a reader looks at the `Prose rewrite` cause
  - Then it says to grep `ravintio-zero/tests/` for each changed sentence and list the matches in the execution plan
- [ ] AC-2: the scan names the cause and stays small
  - Given the scan text of the plan skill and its reference
  - When a test reads and counts it
  - Then the text names `Prose rewrite` and holds 20 lines or fewer
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
