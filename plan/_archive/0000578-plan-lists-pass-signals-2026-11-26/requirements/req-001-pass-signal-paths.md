---
title: "Requirement: REQ-001 - Pass signal paths step"
summary: "The plan skill has a step that lists every path producing a pass signal, including launcher failures."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Pass signal paths step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000578-plan-lists-pass-signals
**Version:** 0.145.0
**Source:** US-001
**Priority:** must-have

## User Story

As a plan author, I list every path to a pass signal, launcher failures included. Each path then has an acceptance criterion.

## Functional Requirements
- `skills/ravintio-plan/SKILL.md` holds a `## Pass signal paths` section.
- The section applies when a requirement judges another component by its exit code or another pass signal.
- The section says to name the pass signal and to list each path that produces it.
- The section says the list includes the failure paths of any launcher between the check and the component.
- The section says each path gets an acceptance criterion, and a failure path must fail the check.
- The combined `SKILL.md` text stays at or under 1720 lines.

## Acceptance Criteria
- [ ] AC-1: the section holds the pass signal wording
  - Given the plan skill
  - When a test reads the `## Pass signal paths` section
  - Then it names a pass signal, each path, a launcher, and an acceptance criterion for each path
- [ ] AC-2: the section says a failure path fails the check
  - Given the `## Pass signal paths` section
  - When a test reads it
  - Then it says a launcher failure that shares the pass signal must fail the check
- [ ] AC-3: the skill stays within its caps and both trees match
  - Given the two pack trees
  - When a reader counts the skill text and compares the plan skill
  - Then the combined text holds 1720 lines or fewer and the two files are identical

## Dependencies
- None
