---
title: "Requirement: REQ-003 - roadmap standards setup stop"
summary: "The roadmap standards document the Setup: stop."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - roadmap standards setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Source:** US-003
**Priority:** must-have

## User Story

As a pack maintainer, I want the stop documented, so that the driver, the skill, and the standards agree.

## Functional Requirements

- `ravintio-zero/standards/roadmap-standards.md` gets a `#### Setup stop` section after `#### Restart stop`.
- The section names the watched paths, the stop line, the combined line, the exit code, and the skill's rerun steps.
- `ravintio-zero/component.yml` lists the stop under `responsibilities`.

## Acceptance Criteria

- [ ] AC-1: the standards name the stop
  - Given `roadmap-standards.md`
  - When a test reads the `#### Setup stop` section
  - Then it holds `I-D Advance: Setup:`, `Restart: Setup:`, and each watched path
- [ ] AC-2: the manifest lists the stop
  - Given `component.yml`
  - When a test reads `responsibilities`
  - Then an entry names the `Setup:` stop

## Dependencies

- REQ-001 and REQ-002 for the wording
