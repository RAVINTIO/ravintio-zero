---
title: "Requirement: REQ-002 - Driver runs the approved setup command"
summary: "At a Setup: stop the driver runs the approved command and continues, and it stops when the row is missing, the form differs, or the command fails."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Driver runs the approved setup command

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I let the driver rerun the approved setup command at a `Setup:` stop, so that the run continues with no restart.

## Functional Requirements
- Both driver paths call the helper at a `Setup:` hit, which includes the check after the last step.
- If the helper returns a command, the driver runs it in the root with `bash`, an argument array, and no shell. It prints `I-D Advance: Setup: step {n} ran the approved setup command` and carries on.
- Before it runs the command, the driver checks that the root holds the merged initiative ref. If the root sits on the initiative branch behind the ref, the driver fast-forwards it. Otherwise the driver stops with the usual `Setup:` line.
- If the helper returns `null`, or the command exits non-zero, the driver stops with the usual `Setup:` line.
- If the hit also names a restart file, the driver runs the command and then stops with the `Restart:` line.

## Acceptance Criteria
- [ ] AC-1: valid row continues
  - Given a chart with the setup `Confirmation:` row and a step that changes a skill file
  - When the driver merges the step
  - Then the command runs once, the driver prints the ran line, and step 2 starts
- [ ] AC-2: no row, different form, or failure stops
  - Given a chart with no row, a row with another command, or a command that exits 1
  - When the driver merges a step that changes a skill file
  - Then the driver prints the `Setup:` line, exits 1, and starts no step 2
- [ ] AC-3: restart still stops
  - Given a valid row and a step that changes `initiative-run.mjs` and a skill file
  - When the driver merges the step
  - Then the command runs and the driver prints a `Restart:` line and exits 1

## Dependencies
- REQ-001
