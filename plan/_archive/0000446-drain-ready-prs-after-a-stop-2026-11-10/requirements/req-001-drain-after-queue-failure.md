---
title: "Requirement: REQ-001 - Drain after a queue failure"
summary: "The driver keeps queueing ready PRs after one queue failure."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Drain after a queue failure

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000446-drain-ready-prs-after-a-stop
**Source:** US-001
**Priority:** must-have

## User Story

As the initiative coordinator, I want the driver to merge other ready PRs after a queue failure, so that independent steps do not wait.

## Functional Requirements
- After a queue failure, `schedule()` in `initiative-run.mjs` keeps taking ready steps from the ready list.
- The driver queues each ready step at most once per run.
- The failed step ends in state `stopped`, and its `ready` file stays.
- Each failure prints `I-D Advance: Blocked: queue stopped on step {n}`.
- The first stop line still ends the run with exit code 1. New steps still do not start.

## Acceptance Criteria
- [ ] AC-1: Another ready PR merges
  - Given steps 1 and 2 have ready PRs and the queue fails on step 1
  - When the driver runs
  - Then the queue runs for step 2 and step 2 shows `merged` on the initiative branch
- [ ] AC-2: The failure stays visible
  - Given the queue fails on step 1
  - When the driver ends
  - Then it exits 1, prints `queue stopped on step 1`, and reports step 1 as `stopped`
- [ ] AC-3: One attempt per step
  - Given every ready PR fails in the queue
  - When the driver runs
  - Then the queue runs once for each step and the driver exits 1

## Dependencies
- `merge-queue.mjs run`, unchanged.
