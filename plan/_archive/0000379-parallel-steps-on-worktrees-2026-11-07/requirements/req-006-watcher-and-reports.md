---
title: "Requirement: REQ-006 - Watcher and skill reports"
summary: "Watcher and skill reports"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-006 - Watcher and skill reports

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-005
**Priority:** should-have

## User Story

As a coordinator, I see every running step in the watcher and in progress reports.

## Functional Requirements

- `initiative-watch.mjs` reads every `plan/.initiative-logs/step-{n}.log` of a running step and prints each step's activity lines with the step number.
- The initiative skill reports each running step in interval and progress reports.

## Acceptance Criteria

- [ ] AC-1: the watcher names each step
  - Given two running step logs
  - When the watcher polls
  - Then it prints lines for both, each with its step number
- [ ] AC-2: the skill describes concurrent reports
  - Given the initiative skill
  - When a test reads it
  - Then it tells the coordinator to report each running step

## Dependencies

- REQ-003
