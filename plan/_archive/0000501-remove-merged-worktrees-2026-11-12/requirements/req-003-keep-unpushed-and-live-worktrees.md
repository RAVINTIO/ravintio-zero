---
title: "Requirement: REQ-003 - Keep unpushed and live worktrees"
summary: "The sweep keeps a merged worktree whose head is off its origin branch or that has a live session."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Keep unpushed and live worktrees

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the driver to keep a worktree with unpushed commits or a live session, so that I lose no work.

## Functional Requirements
- The sweep runs `git ls-remote --heads origin feat/{feature-id}`.
- If the branch exists on origin, the head must equal its commit or sit below it. If not, the driver keeps the worktree. It prints `I-C Run: Kept: step {n} worktree head is not on origin/feat/{feature-id}`.
- If the branch no longer exists on origin, the head check passes.
- If `ls-remote` fails, the driver keeps the worktree and prints `could not be inspected`.
- If the `running` file of the step names a live pid, the driver keeps the worktree and prints `a session still runs`.

## Acceptance Criteria
- [ ] AC-1: unpushed commit, worktree stays
  - Given the worktree head holds a commit that origin lacks, and the origin branch exists
  - When the driver starts
  - Then the worktree remains
  - And the output holds `is not on origin`
- [ ] AC-2: origin branch gone, worktree goes
  - Given origin has no branch for the merged step and the tree is clean
  - When the driver starts
  - Then the worktree is gone
- [ ] AC-3: live session, worktree stays
  - Given the `running` file of merged step 1 names a live pid
  - When the driver starts
  - Then the worktree remains
  - And the output holds `a session still runs`

## Dependencies
- REQ-001.
