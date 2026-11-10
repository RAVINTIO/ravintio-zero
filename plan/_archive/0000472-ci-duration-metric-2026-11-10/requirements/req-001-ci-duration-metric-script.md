---
title: "Requirement: REQ-001 - CI duration in the metrics script"
summary: "workflow-metrics.mjs reports the longest CI duration marker against the ci-duration-seconds threshold."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - CI duration in the metrics script

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000472-ci-duration-metric
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see the longest CI run of a feature in the governance report, so that CI growth shows before it hurts.

## Functional Requirements
- `workflow-metrics.mjs` counts a line that starts with `CI duration: {n}s (` as a marker, with the same prefix and fence rules as the other markers.
- The report holds a fifth row, `Longest CI run (seconds)`, with the highest `{n}` and the run id, the threshold, and `ok` or `breach`.
- The threshold comes from the `ci-duration-seconds` key of the Thresholds table. A missing or non-numeric value exits 1 like the other keys.
- A breach never changes the exit code. A log with no marker shows `0` and `ok`.

## Acceptance Criteria
- [ ] AC-1: longest run row
  - Given a build log with two `CI duration:` markers of 280 and 310 seconds
  - When the script runs
  - Then the report shows a `Longest CI run (seconds)` row with 310 and `ok`
- [ ] AC-2: breach
  - Given a marker of 500 seconds and a threshold of 420
  - When the script runs
  - Then the row shows `breach` and the exit code is 0
- [ ] AC-3: no marker
  - Given a build log with no `CI duration:` marker
  - When the script runs
  - Then the row shows 0 and `ok`

## Dependencies
- none
