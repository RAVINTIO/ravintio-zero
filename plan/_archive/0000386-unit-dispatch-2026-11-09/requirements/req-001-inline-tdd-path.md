---
title: "Requirement: REQ-001 - inline TDD path"
summary: "A content unit that applies agreed text or changes one file runs the TDD loop inline, with RED logged before GREEN."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - inline TDD path

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000386-unit-dispatch
**Source:** US-001
**Priority:** must-have

## User Story

As a pipeline maintainer, I run a small content unit inline with its RED marker before its GREEN marker, so that the build log shows no departure.

## Functional Requirements
- `ravintio-implement` defines an inline unit as a unit of class `content` that applies agreed text or changes one file.
- An inline unit writes its failing test, appends `- RED: {unit} ({ISO-8601 timestamp})`, makes the change, and appends `- GREEN: {unit} ({ISO-8601 timestamp})`. It dispatches no subagent and skips the improvement loop.
- A unit that is not inline runs the test-writer, implementer, and refactor subagents, as before.
- `workflow-governance-standards.md` lists the `RED:` and `GREEN:` markers.
- `build-log-check.mjs` reports a `GREEN:` marker with no earlier `RED:` marker for the same unit. It reports a `Done:` line with tier `inline` that lacks either marker. It adds no finding for a valid inline unit.

## Acceptance Criteria
- [ ] AC-1: the skill names the rule
  - Given the `ravintio-implement` skill text
  - When a reader looks for the inline unit rule
  - Then the skill defines the inline unit, the markers, and the skipped steps
- [ ] AC-2: a valid inline unit passes the check
  - Given a build log with `RED:`, `GREEN:`, and a `Done:` line with tier `inline` for one unit
  - When `build-log-check.mjs` runs
  - Then it reports no finding for that unit
- [ ] AC-3: a missing RED marker is a finding
  - Given a build log with a `GREEN:` marker and no earlier `RED:` marker for a unit
  - When `build-log-check.mjs` runs
  - Then it exits 1 and names the unit

## Dependencies
- none
