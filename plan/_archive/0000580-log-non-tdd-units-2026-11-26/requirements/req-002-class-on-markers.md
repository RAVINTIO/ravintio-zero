---
title: "Requirement: REQ-002 - Class on markers"
summary: "build-log-mark.mjs writes RED and GREEN lines that carry a class."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Class on markers

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000580-log-non-tdd-units
**Source:** US-002
**Priority:** must-have

## User Story

As a pipeline agent, I append `RED:` and `GREEN:` lines with the class, so that the log shows the unit has no failing test.

## Functional Requirements
- `build-log-mark.mjs RED|GREEN {unit} --class {class}` writes `- RED: {unit} ({class}, {time})`.
- Without `--class` the line keeps the form `- RED: {unit} ({time})`.
- The script refuses a class value that holds a comma, a parenthesis, or a line break.

## Acceptance Criteria
- [ ] AC-1: Class on a marker
  - Given a build log
  - When the agent runs the script for `GREEN` with `--class docs`
  - Then the last line reads `- GREEN: {unit} (docs, {time})`
- [ ] AC-2: Old form kept
  - Given a build log
  - When the agent runs the script for `RED` with no `--class`
  - Then the last line reads `- RED: {unit} ({time})`
- [ ] AC-3: Bad class refused
  - Given a build log
  - When the agent runs the script with `--class a,b`
  - Then the script exits 2 and changes no file

## Dependencies
- REQ-001 (the class list)
