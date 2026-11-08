---
title: "Requirement: req-005 - Clear first run"
summary: "Help, a clean banner, correct docs, and block messages that name a next step."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - Clear first run

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-005
**Priority:** must-have

## User Story

As a new developer, I get unblocked from the docs and messages alone.

## Functional Requirements

- `--help` exits 0 and lists every flag, in `setup.sh` and `setup.ps1`.
- `setup.sh` holds no invalid UTF-8, and the banner prints a plain rule.
- The getting-started guide has a day-to-day commands table with pause, park, and skip. It names `ravintio-overrides/capability-skills/`. Setup output names it too.
- Each hook block message names a next step.
- The docs state the correct skill count.

## Acceptance Criteria

- [ ] AC-1: Help
  - Given `setup.sh --help`
  - When it runs
  - Then it exits 0 and lists every flag
- [ ] AC-2: Clean bytes
  - Given `setup.sh`
  - When a UTF-8 check reads it
  - Then it finds no invalid sequence
- [ ] AC-3: Next steps
  - Given each hook block message
  - When a test reads it
  - Then it names a next step

## Dependencies

- None
