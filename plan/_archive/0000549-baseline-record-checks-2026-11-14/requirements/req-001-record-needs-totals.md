---
title: "Requirement: REQ-001 - Record needs a finished run"
summary: "baseline-failures.mjs record refuses runner output that has no totals line."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Record needs a finished run

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000549-baseline-record-checks
**Source:** US-001
**Priority:** must-have

## User Story

As a step agent, I run `record` on runner output, so that output with no `Feature suites:` line exits 2 and writes no file.

## Functional Requirements
- `record` looks for a line that starts with `Feature suites:` in its input.
- If the line is absent, `record` prints one line to stderr and exits 2.
- If the line is absent, `record` writes no baseline file.
- If the line is present, `record` behaves as before.

## Acceptance Criteria
- [ ] AC-1: Partial output exits 2
  - Given runner output that holds no `Feature suites:` line
  - When the agent runs `record` on it
  - Then the exit code is 2 and stderr holds one line that names the missing totals line
  - And the baseline file does not exist
- [ ] AC-2: Finished output records
  - Given runner output that holds a `Feature suites:` line and no failed suites
  - When the agent runs `record` on it
  - Then the exit code is 0 and the file lists `None.`

## Dependencies
- None
