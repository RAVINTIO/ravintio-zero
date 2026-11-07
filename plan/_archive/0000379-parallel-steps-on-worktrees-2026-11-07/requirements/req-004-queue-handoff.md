---
title: "Requirement: REQ-004 - Queue hand-off"
summary: "Queue hand-off"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Queue hand-off

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-003
**Priority:** must-have

## User Story

As a coordinator, I want each ready step PR merged by the merge queue, so that versions follow merge order.

## Functional Requirements

- A step under the concurrent driver (`RAVINTIO_INITIATIVE_QUEUE=1`) ends at ready. It raises the PR, waits for CI, writes the PR number to `$RAVINTIO_INITIATIVE_CONTROL/ready`, and prints `I-D Advance: Ready: PR #{n}`. It does not edit the chart, bump a version, or merge.
- When the variable is unset, the step runs `node ravintio-zero/scripts/merge-queue.mjs run --step {n} --pr {k}` itself after CI is green. P4 sets no version in either case.
- The driver reads `ready`, removes the step's worktree, and runs the merge queue for the PR in a queue worktree at `plan/.initiative-worktrees/queue`, one PR at a time in ready order.
- `merge-queue.mjs` also sets the chart `**Position:**` to the lowest step that has not merged.
- A queue failure stops new starts and prints the queue's error as `I-D Advance: Blocked: queue stopped on step {n}`.

## Acceptance Criteria

- [ ] AC-1: two steps merge through the queue
  - Given two stub steps that each write `ready`
  - When the driver runs
  - Then it runs the queue once per PR, in ready order, and both rows read `merged`
- [ ] AC-2: the queue sets the position
  - Given a chart where step 2 merged and step 1 did not
  - When the queue updates the chart
  - Then `**Position:**` reads 1
- [ ] AC-3: a queue failure stops the driver
  - Given a queue that exits 1
  - When the driver reads the result
  - Then it starts no new step and prints a `Blocked:` line that names the step

## Dependencies

- REQ-003, step 2 merge queue
