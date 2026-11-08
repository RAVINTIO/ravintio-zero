---
title: "Requirement: req-001 - Reference file edits"
summary: "Reference file edits"
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Reference file edits

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000383-test-impact-scan
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I get the frozen-line tests listed when a run edits a skill's `references/` file, so that P2 finds them before the full suite.

## Functional Requirements

- The Test impact scan names a cause: the run edits a file in a skill's `references/` folder.
- The cause tells the planner to grep `ravintio-zero/tests/` for the file name.

## Acceptance Criteria

- [ ] AC-1: Cause named
  - Given the plan skill
  - When a test reads its `## Test impact scan` section
  - Then the section names the `references/` cause and the file name grep

## Dependencies

- None
