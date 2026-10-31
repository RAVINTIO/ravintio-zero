---
title: "Requirement: REQ-001 - phase guard skips step logs"
summary: "phase guard skips step logs."
status: "active"
version: "0.41.1"
---
# Requirement: REQ-001 - phase guard skips step logs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000314-step-logs-stay-in-place
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I run the suite with a populated step log, so that the phase guard suites pass without moving files.

## Functional Requirements

- Add `plan/.initiative-logs` to `EXCLUDE` in `test-0000042-req-006-phase-guard-and-stale-cites.sh`.
- The guard still scans every other path in `SCOPE`.

## Acceptance Criteria

- [ ] AC-1: a populated step log passes
  - Given a workspace with a step log that holds `P7` and `PL:`
  - When the phase guard runs
  - Then it exits 0
- [ ] AC-2: a tracked stale cite still fails
  - Given the same workspace with `P6` planted in a tracked skill
  - When the phase guard runs
  - Then it exits 1 and names the skill file and line

## Dependencies

none
