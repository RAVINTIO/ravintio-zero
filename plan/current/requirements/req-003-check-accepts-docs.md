---
title: "Requirement: REQ-003 - Check 7 accepts a docs unit"
summary: "build-log-check.mjs passes a docs unit with both markers and fails one without them."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Check 7 accepts a docs unit

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Source:** US-003
**Priority:** must-have

## User Story

As a reviewer, I run `build-log-check.mjs` on a log with a `docs` unit, so that it passes with both markers and fails without them.

## Functional Requirements
- Check 7 requires a `RED:` and a `GREEN:` line for each `Done:` line whose class is `docs`, as it does for tier `inline`.
- A marker line that carries a class still matches check 7.
- No other check changes. An older `Done:` line still passes.

## Acceptance Criteria
- [ ] AC-1: Docs unit with markers
  - Given a log with `RED:`, `GREEN:`, and a `Done:` line of class `docs`
  - When the agent runs the check
  - Then check 7 reports no finding
- [ ] AC-2: Docs unit without markers
  - Given a log with a `Done:` line of class `docs` and no marker
  - When the agent runs the check
  - Then the check exits 1 and names the missing `RED:` and `GREEN:` lines
- [ ] AC-3: Older line
  - Given a log with an older `Done:` line that has no class fields
  - When the agent runs the check
  - Then check 7 reports no finding

## Dependencies
- REQ-002 (the marker form)
