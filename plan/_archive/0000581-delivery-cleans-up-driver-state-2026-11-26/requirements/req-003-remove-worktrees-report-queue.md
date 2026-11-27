---
title: "Requirement: REQ-003 - The cleanup removes worktrees and reports the queue"
summary: "The script removes each step worktree, prunes, and lists each queue item it leaves."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - The cleanup removes worktrees and reports the queue

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000581-delivery-cleans-up-driver-state
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one script after the initiative PR merges, so that the driver state of the delivered initiative leaves `plan/`.

## Functional Requirements
- The script runs `git worktree remove --force` for each folder under `plan/.initiative-worktrees/`, then `git worktree prune`.
- A failed removal prints `I-E Delivery: Kept: {path}: {reason}` and never stops the run.
- The script leaves `plan/.initiative-queue/` in place. It prints `I-E Delivery: Kept: queue item {name}` for each item.
- The script removes no path outside the repo root.

## Acceptance Criteria
- [ ] AC-1: Worktrees go
  - Given a repo with two worktrees under `plan/.initiative-worktrees/`
  - When the script runs
  - Then neither folder exists and `git worktree list` names only the main tree
- [ ] AC-2: The queue stays
  - Given two items in `plan/.initiative-queue/`
  - When the script runs
  - Then both items remain and the output names each
- [ ] AC-3: A failed removal does not stop the run
  - Given a worktree folder that git does not know
  - When the script runs
  - Then it prints a `Kept:` line and still archives the folders

## Dependencies
- REQ-001.
