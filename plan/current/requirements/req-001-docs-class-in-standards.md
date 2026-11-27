---
title: "Requirement: REQ-001 - Docs class in the dispatch standards"
summary: "The dispatch standards name class docs, its tier row, and its marker rule."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Docs class in the dispatch standards

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Source:** US-001
**Priority:** must-have

## User Story

As a pipeline agent, I log a unit with no executable check as class `docs`, so that its `Done:` line is valid.

## Functional Requirements
- `dispatch-unit-classes` names five classes and defines `docs` as a unit that changes living documents and has no executable check.
- The tier table holds a `docs` row that matches the `content` row.
- A rule `dispatch-docs-markers` says a `docs` unit still logs `RED:` and `GREEN:` lines. Each line carries the class. The `GREEN:` line names the check that passed.
- `build-log.template.md` shows the class on the marker lines.

## Acceptance Criteria
- [ ] AC-1: Class defined
  - Given the dispatch standards
  - When a reader looks up rule `dispatch-unit-classes`
  - Then it names `docs` with the other four classes
- [ ] AC-2: Marker rule defined
  - Given the dispatch standards
  - When a reader looks up rule `dispatch-docs-markers`
  - Then it requires both markers for a `docs` unit and names `build-log-mark.mjs --class`

## Dependencies
- None
