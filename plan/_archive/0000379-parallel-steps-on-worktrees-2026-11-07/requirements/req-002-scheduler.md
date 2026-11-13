---
title: "Requirement: REQ-002 - Scheduler"
summary: "Scheduler"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Scheduler

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I run up to `**Concurrency:**` steps at once in worktrees, so that independent steps overlap.

## Functional Requirements

- When the chart holds `**Concurrency:**`, `initiative-run.mjs` runs the scheduler. Without the field it runs the serial path unchanged.
- A step is ready when its row is `pending`, every step in its `After` has merged, and no running step shares its lane.
- The driver starts ready steps in chart order until the running count equals `**Concurrency:**`.
- Steps in one lane run in chart order. A `ready` step (PR raised, not yet merged) still holds its lane until it merges.
- The driver ends when every row has merged. It then prints the same `I-E Delivery:` lines as today.

## Acceptance Criteria

- [ ] AC-1: different lanes run at once
  - Given a chart with two pending steps in different lanes, no `After`, and `**Concurrency:** 2`
  - When the driver runs with a stub `claude`
  - Then both stub sessions overlap in time and both steps merge
- [ ] AC-2: one lane or an `After` link runs in order
  - Given two steps in one lane, or linked by `After`
  - When the driver runs
  - Then the second starts only after the first merges
- [ ] AC-3: the cap holds
  - Given three independent steps and `**Concurrency:** 2`
  - When the driver runs
  - Then never more than two sessions run at once

## Dependencies

- REQ-001
