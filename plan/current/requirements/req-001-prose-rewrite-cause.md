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
- [ ] AC-1: the cause exists
  - Given the reference file
  - When a reader looks for the `Prose rewrite` cause
  - Then the cause says to grep `ravintio-zero/tests/` for each changed sentence
- [ ] AC-2: the cause asks for a list of matches
  - Given the cause
  - When a run rewrites prose
  - Then the cause says to list the matches in the execution plan
- [ ] AC-3: the plan skill names the cause
  - Given the scan text of the plan skill and its reference
  - When a test reads it
  - Then the text names `Prose rewrite`
- [ ] AC-4: the scan stays small
  - Given the scan text
  - When a test counts its lines
  - Then the count is 20 or fewer
- [ ] AC-5: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
