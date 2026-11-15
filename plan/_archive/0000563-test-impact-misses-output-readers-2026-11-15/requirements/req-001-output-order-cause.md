---
title: "Requirement: REQ-001 - Output order cause"
summary: "The scan lists suites that read changed lines or the last line when a run changes printed output."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Output order cause

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000563-test-impact-misses-output-readers
**Version:** 0.121.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I see an `Output order` cause, so that I list suites that read changed lines or the last line.

## Functional Requirements
- The reference file holds an `Output order` cause.
- The cause fires when the run adds, removes, or moves a printed line of a script.
- The cause tells the author to search the tests folder for suites that match the changed line text.
- The cause tells the author to search for suites that read the last line of the output.

## Acceptance Criteria
- [ ] AC-1: cause named
  - Given the reference file
  - When a reader looks for the cause
  - Then it reads `Output order`
- [ ] AC-2: both readers listed
  - Given the cause
  - When a run changes a printed line
  - Then the cause names suites that match the line text and suites that read the last line
- [ ] AC-3: both trees match
  - Given the two pack trees
  - When a reader compares the reference file
  - Then the files are identical

## Dependencies
- None
