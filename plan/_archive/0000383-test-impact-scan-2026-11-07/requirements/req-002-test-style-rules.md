---
title: "Requirement: req-002 - Test style rules"
summary: "Test style rules"
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Test style rules

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Source:** US-002
**Priority:** must-have

## User Story

As a test author, I get the repo-wide style tests listed when a run adds a test file, so that I read them first.

## Functional Requirements

- The scan names a cause: the run adds a test file.
- The cause lists the repo-wide style tests under `ravintio-zero/tests/`, such as `test-0000164-req-008`, so the test writer reads them first.

## Acceptance Criteria

- [ ] AC-1: Cause named
  - Given the plan skill
  - When a test reads its scan section
  - Then the section names the new test file cause and the style tests

## Dependencies

- None
