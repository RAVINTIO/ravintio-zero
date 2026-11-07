---
title: "Requirement: REQ-003 - Setup check after the last step"
summary: "The driver prints a Setup stop before delivery pending."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Setup check after the last step

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000377-driver-stops-and-headroom
**Source:** US-003
**Priority:** must-have

## User Story

As the human on the loop, I see a `Setup:` stop before `I-E Delivery: Pending:`, so that delivery runs on current installed skills.

## Functional Requirements
- After the last step merges, the driver runs the setup change check before it prints `I-E Delivery: Pending:`.
- If the check finds changed files, the driver prints the `Setup:` line and exits 1.
- `roadmap-standards.md` and the driver header describe the order.

## Acceptance Criteria
- [ ] AC-7: Setup stop on last step
  - Given the last step changed a pack file that setup installs
  - When the step merges
  - Then the driver prints `I-D Advance: Setup:` with the files and exits 1, with no `Pending:` line
- [ ] AC-8: Pending when nothing changed
  - Given the last step changed no setup file
  - When the step merges
  - Then the driver prints `I-E Delivery: Pending:` and exits 0
- [ ] AC-9: Docs and suite
  - Given the finished change
  - When the full local suite runs
  - Then it passes and the standards and header comments describe all three behaviours

## Dependencies
- None.
