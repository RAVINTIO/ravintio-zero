---
title: "Requirement: REQ-001 - Sweep merged worktrees"
summary: "At start, the driver removes the safe worktree of each merged step and leaves other worktrees alone."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Sweep merged worktrees

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000501-remove-merged-worktrees
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the driver to remove a safe merged worktree, so that old worktrees do not pile up.

## Functional Requirements
- After `schedule()` reads the chart and the control folders, it visits each step that the chart marks `merged`.
- If `plan/.initiative-worktrees/step-{n}` exists and is safe, the driver removes it with `git worktree remove --force`.
- A worktree is safe under REQ-002 and REQ-003.
- The sweep leaves alone the worktree of an unmerged step, the queue worktree, and every control folder.
- The sweep prints nothing for a step that has no worktree.

## Acceptance Criteria
- [ ] AC-1: clean merged worktree goes
  - Given the chart marks step 1 merged and its worktree is clean and pushed
  - When the driver starts
  - Then the worktree is gone
- [ ] AC-2: unmerged worktree stays
  - Given the chart marks step 2 `pending` and step 2 has a worktree
  - When the driver starts
  - Then the worktree of step 2 remains
- [ ] AC-3: no worktree, no output
  - Given the chart marks step 1 `merged` and step 1 has no worktree
  - When the driver starts
  - Then the driver prints no `Kept:` line

## Dependencies
- `schedule()` and `removeWorktree()` in `initiative-run.mjs`.
