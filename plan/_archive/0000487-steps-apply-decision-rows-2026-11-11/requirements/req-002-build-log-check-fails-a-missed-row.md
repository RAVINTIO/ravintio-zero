---
title: "Requirement: REQ-002 - The build log check fails a missed row"
summary: "build-log-check.mjs fails a build log that has no line for a Decisions row that names its step."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - The build log check fails a missed row

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000487-steps-apply-decision-rows
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want ship to fail a log that misses a row, so that a skipped row stops.

## Functional Requirements
- `build-log-check.mjs` gains check 9. It reads the Feature ID from the build log header and finds the chart row with that Feature id.
- The chart is `plan/current-initiative/initiative.md`, found from the project root of the build log path. A missing chart or no matching row skips the check.
- For each row that `rowsForStep` returns, the log needs a line that starts `Decision applied (initiative chart): {fork}` or `Decision not applicable (initiative chart): {fork}`. The line may start with a list marker.
- A finding reads `Decisions: no log line for the row "{fork}"` and names the step.
- The check adds no finding to a log outside an initiative.

## Acceptance Criteria
- [ ] AC-1: a missed row fails
  - Given a chart row `25-41` and a log for step 40 with no line for it
  - When the check runs
  - Then it exits 1 and the finding names the fork
- [ ] AC-2: a logged row passes
  - Given the same chart and a `Decision applied` line, or a `Decision not applicable` line
  - When the check runs
  - Then it adds no finding
- [ ] AC-3: no chart passes
  - Given a log with no chart in the project
  - When the check runs
  - Then it adds no finding

## Dependencies
- REQ-001.
