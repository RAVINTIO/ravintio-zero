---
title: "Requirement: req-002 - Baseline failures"
summary: "P0 records base-commit failures and P3 stops only on new ones."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Baseline failures

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000385-faster-test-runs
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I want P0 to record base-commit failures, so that P3 stops only on failures my run caused.

## Functional Requirements

- `baseline-failures.mjs record` reads runner output and writes the failed suite names to `plan/current/baseline-failures.md`.
- `baseline-failures.mjs check` reads runner output, prints each new and each inherited suite, and exits 1 when any suite is new.
- A missing baseline file counts as an empty baseline.
- The P0 start actions run the suite on the base commit and call `record`. P3 calls `check`. The build report lists inherited suites and offers a backlog entry for each.

## Acceptance Criteria

- [ ] AC-1: Matching failures pass
  - Given a baseline that lists suite A
  - When `check` reads output whose only failed suite is A
  - Then it exits 0 and prints A as inherited
- [ ] AC-2: A new failure stops
  - Given a baseline that lists suite A
  - When `check` reads output that also fails suite B
  - Then it exits 1 and prints B as new
- [ ] AC-3: No baseline file
  - Given no baseline file
  - When `check` reads output with one failed suite
  - Then it exits 1

## Dependencies

- None
