---
title: "Requirement: REQ-002 - build log times from the clock"
summary: "Phase skills read the clock, and the build log check fails a logged time later than its commit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - build log times from the clock

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000358-clean-step-stops-and-logs
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find that every phase reads `date -u +%Y-%m-%dT%H:%M:%SZ` and `build-log-check.mjs` fails a time later than the commit that adds it, so that a guessed time never reaches ship.

## Functional Requirements
- The orchestrator, plan, implement, validate-and-accept, and ship skills tell the phase to read `date -u +%Y-%m-%dT%H:%M:%SZ` for every logged time and never type one.
- `build-log-check.mjs` finds each ISO time in the log, finds the commit that added its line, and reports a finding when the time is later than that commit's time. A one-minute margin applies.
- If git cannot read the history of the log, the time check skips.
- A time on a line not yet committed is compared with the current clock.

## Acceptance Criteria
- [ ] AC-1: skills name the clock command
  - Given the five skills
  - When a test reads them
  - Then each holds `date -u +%Y-%m-%dT%H:%M:%SZ`
- [ ] AC-2: future time fails
  - Given a fixture repo whose log commit holds a time an hour later than the commit
  - When the check runs
  - Then it exits 1 and names the phase
- [ ] AC-3: honest time passes
  - Given a fixture log whose times are at or before their commits
  - When the check runs
  - Then it reports no time finding

## Dependencies
- None.
