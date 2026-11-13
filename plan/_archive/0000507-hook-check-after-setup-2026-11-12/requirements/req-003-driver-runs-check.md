---
title: "Requirement: REQ-003 - Driver runs the check after setup"
summary: "The driver runs the hook check after it runs setup and stops with a Blocked line on a failure."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-003 - Driver runs the check after setup

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Source:** US-002
**Priority:** must-have

## User Story

As the driver, I run the check after setup and stop on a failure, so that a broken hook never reaches a step.

## Functional Requirements
- After `approvedSetup` in `initiative-run.mjs` runs the setup command with a clean exit, the driver runs `hook-check.mjs`.
- If the check passes, the driver carries on as before.
- If the check fails, the driver prints a line that starts `Blocked:` and names each failing hook, releases the lock, and exits 1.
- A setup command that fails keeps its existing stop.

## Acceptance Criteria
- [ ] AC-1: pass carries on
  - Given an approved setup command that exits 0 and a passing hook check
  - When the driver reaches the Setup hit
  - Then the driver prints the existing approved-setup line and starts the next step
- [ ] AC-2: failure stops
  - Given an approved setup command that exits 0 and a failing hook check
  - When the driver reaches the Setup hit
  - Then the driver prints a `Blocked:` line that names the failing hook, releases the lock, and exits 1
- [ ] AC-3: no early run
  - Given a setup command that fails
  - When the driver reaches the Setup hit
  - Then the driver does not run the hook check

## Dependencies
- REQ-001
- REQ-002
