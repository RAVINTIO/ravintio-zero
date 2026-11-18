---
title: "Requirement: REQ-001 - Driver removes a merged step's temp paths"
summary: "After the queue merges a step, the driver removes the step's temp paths and extra worktrees."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Driver removes a merged step's temp paths

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Source:** US-001
**Priority:** must-have

## User Story

As the driver, I remove a merged step's temp paths and extra worktrees and prune, so that a merged step leaves nothing behind.

## Functional Requirements
- After `removeControl`, the driver calls `cleanStepTemp(root, n)` for the merged step.
- The call removes each worktree that git lists outside `plan/.initiative-worktrees/` when its folder name matches `^step{n}(?![0-9])`. It then runs `git worktree prune`.
- The call removes each entry of the temp folders that matches the same pattern. The folders are `os.tmpdir()` and `/tmp`, or the list in `RAVINTIO_STEP_TEMP_DIRS` when the variable holds one.
- The removal never follows a symlink.
- A failed removal prints `I-C Run: Kept: step {n} {reason}` and never stops the run.
- The start sweep calls the same function for each merged step in the chart.

## Acceptance Criteria
- [ ] AC-1: Cleanup after a merge
  - Given step 2 merged and the temp folder holds `step2-out`, `step2.log`, and an extra worktree named `step2-basewt`
  - When the driver finishes the merge
  - Then none of the three exists and `git worktree list` omits `step2-basewt`
- [ ] AC-2: Another step stays
  - Given the temp folder also holds `step20-out` and `step1-out`
  - When step 2 merges
  - Then both remain
- [ ] AC-3: A failed removal never stops the run
  - Given a temp entry that cannot be removed
  - When step 2 merges
  - Then the driver prints a `Kept:` line for step 2 and the run goes on

## Dependencies
- The 0000501 sweep of merged worktrees (ADR-0326).
