---
title: "Requirement: REQ-005 - Stops and state report"
summary: "Stops and state report"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Stops and state report

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I want a `Blocked:`, `Question:`, `Restart:`, or `Setup:` line from any step to stop new starts and name every step's state.

## Functional Requirements

- When any running step ends on `Blocked:` or `Question:`, the driver starts no new step. It lets the other running steps reach a safe point (ready or stopped), then stops.
- After a merge, the existing restart and setup checks run. A hit stops new starts the same way.
- The driver prints one line per step with its state (`pending`, `running`, `ready`, `merged`, or `stopped`) before it exits 1.
- A step that exits without ready and without a block follows today's resume rule.

## Acceptance Criteria

- [ ] AC-1: a block stops new starts
  - Given three independent steps, concurrency 2, and a stub that prints `Blocked:` for step 1
  - When the driver runs
  - Then step 3 never starts and the report names each step's state
- [ ] AC-2: the other step finishes
  - Given step 2 is running when step 1 blocks
  - When step 2 reaches ready
  - Then the driver merges it, then stops
- [ ] AC-3: a restart file stops new starts
  - Given a merged step that changed `initiative-run.mjs`
  - When the driver reads the diff
  - Then it prints `Restart:` and starts no new step

## Dependencies

- REQ-004
