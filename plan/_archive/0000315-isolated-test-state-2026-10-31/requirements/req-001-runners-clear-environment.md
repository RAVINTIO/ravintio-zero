---
title: "Requirement: REQ-001 - runners clear RAVINTIO variables"
summary: "runners clear RAVINTIO variables."
status: "active"
version: "0.41.2"
---
# Requirement: REQ-001 - runners clear RAVINTIO variables

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Source:** US-001
**Priority:** must-have

## User Story

As a developer in any session, I run the suite with `RAVINTIO_*` variables set, so that the result matches a clean shell.

## Functional Requirements

- `run-tests.sh` and `run-tests.ps1` remove every `RAVINTIO_*` variable before each suite, except `RAVINTIO_PWSH`, `RAVINTIO_TIMING_FILE`, and `RAVINTIO_TEST_QUIET`. The last one changes only how much a suite prints.
- Each runner header lists the variables it keeps.

## Acceptance Criteria

- [ ] AC-1: variables are cleared
  - Given `RAVINTIO_INITIATIVE_STEP=1` and an unlisted `RAVINTIO_` variable are set
  - When the runner starts a probe suite
  - Then the probe sees both variables unset
- [ ] AC-2: kept variables pass through
  - Given `RAVINTIO_PWSH` is set
  - When the runner starts a probe suite
  - Then the probe sees its value
- [ ] AC-3: quiet mode still works
  - Given `RAVINTIO_TEST_QUIET=1` is set
  - When the runner runs a passing suite
  - Then the output omits the PASS lines and the suite sees the variable

## Dependencies

none
