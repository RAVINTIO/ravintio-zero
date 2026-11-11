---
title: "Requirement: REQ-001 - Keep untracked entries"
summary: "The driver keeps a step worktree that holds untracked backlog entries and stops the queue for that step."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Keep untracked entries

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the driver to keep a worktree that holds untracked backlog entries, so that I lose no filed entry.

## Functional Requirements
- Before `removeWorktree()` removes a step worktree, it runs `git ls-files --others --exclude-standard -- plan/backlog` in that worktree.
- If the command lists a file, the driver keeps the worktree and stops the queue for the step.
- The stop line names up to five files and the count of the rest.
- The step keeps its `ready` file, so a new driver queues it again.

## Acceptance Criteria
- [ ] AC-1: untracked entry, worktree stays
  - Given the step worktree holds an untracked file under `plan/backlog/`
  - When the queue reaches the step
  - Then the worktree and the file remain
  - And the queue does not run for the step
- [ ] AC-2: stop line names the file
  - Given the same worktree
  - When the queue stops
  - Then the output holds `I-D Advance: Blocked: queue stopped on step` and the path of the file

## Dependencies
- `removeWorktree()` and `queueTask()` in `initiative-run.mjs`.
