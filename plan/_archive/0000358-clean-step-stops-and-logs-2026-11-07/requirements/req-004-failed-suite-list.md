---
title: "Requirement: REQ-004 - failed suites by name"
summary: "Both runners print each failed suite's file name after the totals, with or without quiet mode."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - failed suites by name

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Source:** US-004
**Priority:** should-have

## User Story

As a developer, I see each failed suite's file name under the totals, so that one run names every failure.

## Functional Requirements
- `run-tests.sh` and `run-tests.ps1` record the file name of each failed suite, feature and regression.
- Under the totals they print `Failed suites:` and one name per line, before the final verdict line.
- The list prints with `RAVINTIO_TEST_QUIET=1`.
- A run with no failure prints no list.
- The validate skill tells the phase to read the list.

## Acceptance Criteria
- [ ] AC-1: named after totals
  - Given a temporary suite that fails
  - When `run-tests.sh` runs
  - Then the failed suite name appears after the totals
- [ ] AC-2: quiet mode lists too
  - Given the same suite and `RAVINTIO_TEST_QUIET=1`
  - When the runner runs
  - Then the name still appears after the totals
- [ ] AC-3: both runners and the skill agree
  - Given `run-tests.ps1` and the validate skill
  - When a test reads them
  - Then each holds the `Failed suites:` text or points at the list

## Dependencies
- None.
