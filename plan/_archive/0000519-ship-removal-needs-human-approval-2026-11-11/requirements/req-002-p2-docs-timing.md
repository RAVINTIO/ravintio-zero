---
title: "Requirement: REQ-002 - P2 writes docs outside the suite run"
summary: "The implement skill tells the agent to write docs before the full suite starts or after it ends."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - P2 writes docs outside the suite run

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000519-ship-removal-needs-human-approval
**Source:** US-002
**Priority:** must-have

## User Story

As an implementing agent, I write docs outside the full suite run, so that the runner sees no changed tree.

## Functional Requirements
- Rule `implement-full-suite-once` says to write docs before the full suite starts and to change no file until it ends.
- The fast batch line for docs units says they run before the full suite starts.
- The rule keeps the words `one full suite run`, `before P2 completes`, and `background`, which `test-0000385-req-001-affected-tests.sh` pins.

## Acceptance Criteria
- [ ] AC-1: the rule orders docs and suite
  - Given rule `implement-full-suite-once`
  - When a reader looks for the docs timing
  - Then it says to write docs before the suite starts and to change no file until it ends
- [ ] AC-2: no text says to write docs while the suite runs
  - Given the implement skill
  - When a test searches for `write docs` near `suite runs`
  - Then it finds none
- [ ] AC-3: the caps hold
  - Given the edited skills
  - When the size tests run
  - Then all skills total 1,720 lines or fewer

## Dependencies
- None.
