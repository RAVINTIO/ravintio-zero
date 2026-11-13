---
title: "Requirement: REQ-001 - Clear merged ready files"
summary: "At start, the driver removes the ready file of each merged step and leaves other control files alone."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Clear merged ready files

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000509-clear-merged-ready-files
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I want the driver to remove a merged step's `ready` file, so that I do not clear it by hand.

## Functional Requirements
- After `schedule()` reads the chart and the control folders, it visits each step that the chart marks `merged`.
- If `plan/.initiative-control/step-{n}/ready` exists and REQ-002 allows it, the driver removes it.
- The driver prints `I-C Run: Cleared: step {n} ready file of a merged step` for each file it removes.
- The pass leaves alone the `ready` file of an unmerged step, every other file in a control folder, and the folder itself.
- The pass prints nothing for a merged step with no `ready` file.
- A driver that takes over from another (`--handoff`) skips the pass.

## Acceptance Criteria
- [ ] AC-1: merged ready file goes
  - Given the chart marks step 1 merged and its control folder holds a `ready` file
  - When the driver starts
  - Then the file is gone and the driver prints a `Cleared:` line for step 1
- [ ] AC-2: unmerged ready file stays
  - Given the chart marks step 2 `pending` and its control folder holds a `ready` file
  - When the driver starts
  - Then the file remains
- [ ] AC-3: no file, no output
  - Given the chart marks step 1 merged and it has no `ready` file
  - When the driver starts
  - Then the driver prints no `Cleared:` or `Kept:` line for step 1

## Dependencies
- `schedule()` and `readControl()` in `initiative-run.mjs`.
