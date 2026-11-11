---
title: "Requirement: REQ-003 - Standards and skill text"
summary: "The roadmap standards and the initiative skill state that the driver runs the approved setup command."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Standards and skill text

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I let the driver rerun the approved setup command at a `Setup:` stop, so that the run continues with no restart.

## Functional Requirements
- The `Setup stop` section of `roadmap-standards.md` states that the driver runs the `Confirmation:` command and continues.
- The section names the allowed command form and the three stop cases.
- The `Stops` section of the initiative skill says the coordinator reruns setup only when the driver stopped with a `Setup:` line.

## Acceptance Criteria
- [ ] AC-1: standards text
  - Given `roadmap-standards.md`
  - When a reader opens the `Setup stop` section
  - Then it names `setup-command.mjs`, the allowed form, and the stop cases
- [ ] AC-2: skill text
  - Given the initiative skill
  - When a reader opens `Stops`
  - Then it says the driver runs the approved command and a `Setup:` line means that it did not

## Dependencies
- REQ-002
