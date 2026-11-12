---
title: "Requirement: REQ-002 - Keep dirty worktrees"
summary: "The sweep keeps a merged worktree that holds uncommitted files or that git cannot inspect, and names the cause."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Keep dirty worktrees

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I want the driver to keep an unsafe worktree and name its files, so that I lose no work.

## Functional Requirements
- The sweep runs `git status --porcelain -z` in the worktree.
- If the command lists a file, the driver keeps the worktree and prints `I-C Run: Kept: step {n} worktree holds uncommitted files: {files}`. The line names up to five files and the count of the rest.
- If the command fails, the driver keeps the worktree and prints `I-C Run: Kept: step {n} worktree could not be inspected: {last git error line}`.
- A kept worktree does not stop the run.

## Acceptance Criteria
- [ ] AC-1: uncommitted file, worktree stays
  - Given the worktree of merged step 1 holds an untracked file `notes.txt`
  - When the driver starts
  - Then the worktree and the file remain
  - And the output holds `Kept: step 1` and `notes.txt`
- [ ] AC-2: git failure, worktree stays
  - Given git cannot read the worktree of merged step 1
  - When the driver starts
  - Then the worktree remains
  - And the output holds `could not be inspected`
- [ ] AC-3: a kept worktree does not stop the run
  - Given the sweep kept the worktree of step 1
  - When step 2 is ready to start
  - Then step 2 runs and the driver exits 0

## Dependencies
- REQ-001.
