---
title: "Requirement: REQ-001 - Restore written files"
summary: "A queue run that fails before its commit lands restores the files it wrote, so the next run starts clean."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Restore written files

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000546-queue-failure-leaves-dirty-files
**Source:** US-001
**Priority:** must-have

## User Story

As the driver, I run the queue after a failed run, so that the queue worktree holds no files the failed run wrote.

## Functional Requirements
- The queue writes the version files and the chart. If a failure comes before the set-version commit lands, the queue restores those paths to HEAD.
- The restore covers the index and the working tree.
- The restore covers the chart and each existing file in `version-files.txt`. It touches no other path.
- The queue prints `restored: {paths}` when the restore changed a path. The original failure message stays the exit message.
- The restore runs `git restore` on named paths. It never runs `git reset --hard` or `git clean`.
- Both copies of the script carry the change: `src/ravintio-zero/scripts/` and `ravintio-zero/scripts/`.

## Acceptance Criteria
- [ ] AC-1: Rejected commit
  - Given a queue run whose set-version commit a hook rejects
  - When the run fails
  - Then the chart and the version files equal HEAD and the index holds no change
- [ ] AC-2: Other files stay
  - Given an untracked file in the queue worktree
  - When the same run fails
  - Then the untracked file is still there with its content
- [ ] AC-3: Rerun starts clean
  - Given the failed run
  - When the hook stops rejecting and the queue runs again
  - Then the run does not stop with `working tree is not clean`

## Dependencies
- None.
