---
title: "Requirement: req-001 - Section helper"
summary: "A helper returns a named section from SKILL.md and every reference file."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - Section helper

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000380-test-helpers-and-rule-anchors
**Source:** US-001
**Priority:** must-have

## User Story

As a pack maintainer, I fetch a named section through one helper, so that moving a section between `SKILL.md` and a reference file fails no test.

## Functional Requirements

- `orch_section "<heading line>"` returns the section text from `SKILL.md`, the orchestrator references, and the roadmap standards.
- A section runs from its heading to the next heading of the same or higher level, and the helper ignores headings in fenced code.
- Suites that cut a section out with `sed` or `awk` use the helper.

## Acceptance Criteria

- [ ] AC-1: Section found in either place
  - Given a section in `SKILL.md` or in a reference file
  - When a test calls `orch_section` with its heading
  - Then the helper returns the section text and a move between the two files changes no result
- [ ] AC-2: Missing heading fails
  - Given a heading in no file
  - When a test calls `orch_section` with it
  - Then the helper returns a marker line naming the heading and exits non-zero, so the assertion fails

## Dependencies

- None
