---
title: "Requirement: REQ-002 - Remove a clean worktree"
summary: "The driver removes a worktree with no untracked entries as before, and keeps one when git cannot list its files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Remove a clean worktree

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want a clean worktree removed as before, so that the queue keeps merging.

## Functional Requirements
- If the listing is empty, the driver removes the worktree with `git worktree remove --force`, as it does today.
- Untracked files outside `plan/backlog/` do not stop the queue.
- If the listing command fails, the driver keeps the worktree and stops the queue. The stop line carries the last line of the git error.

## Acceptance Criteria
- [ ] AC-1: no untracked entry, worktree goes
  - Given the step worktree holds no untracked file under `plan/backlog/`
  - When the queue reaches the step
  - Then the driver removes the worktree and the step merges
- [ ] AC-2: other untracked files do not stop the queue
  - Given the worktree holds an untracked file outside `plan/backlog/`
  - When the queue reaches the step
  - Then the driver removes the worktree and the step merges
- [ ] AC-3: failed listing, worktree stays
  - Given git cannot list the files of the worktree
  - When the queue reaches the step
  - Then the worktree remains and the queue stops for the step

## Dependencies
- REQ-001.
