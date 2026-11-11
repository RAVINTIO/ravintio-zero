---
title: "Requirement: REQ-004 - Docs and skill text"
summary: "The standards, the driver header, and the initiative skill describe the handoff."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Docs and skill text

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000493-driver-starts-after-restart
**Source:** US-004
**Priority:** must-have

## User Story

As the coordinator, I want the standards and the initiative skill to describe the handoff. I then never start a second driver.

## Functional Requirements
- The `Restart stop` section of `roadmap-standards.md` describes the handoff, its exceptions, and the `stopped` file.
- The header comment of `initiative-run.mjs` describes the same rules.
- On a handoff line, the initiative skill tells the coordinator to start a new watcher only. For every other stop it says to start a driver and a watcher.
- Both pack trees hold identical files.

## Acceptance Criteria
- [ ] AC-1: Standards text
  - Given the standards file
  - When a test reads the `Restart stop` section
  - Then it names the handoff, the `--handoff` flag, and the `stopped` file
- [ ] AC-2: Skill text
  - Given the initiative skill
  - When a test reads the `Restart:` paragraph
  - Then it says the old driver hands over and the coordinator starts a watcher only
- [ ] AC-3: Both trees match
  - Given the two pack trees
  - When a test compares each changed file
  - Then the copies are identical

## Dependencies
- REQ-001 to REQ-003 define the behaviour to describe.
