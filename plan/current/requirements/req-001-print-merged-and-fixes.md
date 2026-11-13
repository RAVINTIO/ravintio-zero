---
title: "Requirement: REQ-001 - Print the merged steps and the fixes"
summary: "At each end of a run, the driver prints the steps it merged and the fixes it made by itself."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Print the merged steps and the fixes

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000511-driver-stop-summary
**Source:** US-001
**Priority:** must-have

## User Story

As the human, I want one block at each driver stop. It lists the merged steps and the driver's own fixes, so I skip the full output.

## Functional Requirements
- `out()` records each line that names a merge (`I-D Advance: Complete: step {n} merged`) and each line that names a driver fix.
- The driver fix lines are `I-C Run: Cleared:`, `I-D Advance: Ready: step {n} recovered`, `I-D Advance: Setup: step {n} ran the approved`, and the `I-C Run: Starting: lock named process` line.
- At every end of a run, the driver prints `I-C Run: Summary: merged this run: {steps in merge order, or none}`.
- It then prints `I-C Run: Summary: driver fixes: {count}` and one `I-C Run: Summary: fix: {line}` for each fix, up to 10.
- The block prints just before the final line of the run, so the stop line or the `I-E Delivery:` line stays last.

## Acceptance Criteria
- [ ] AC-1: the block names a merge
  - Given the driver merges step 2
  - When the run ends
  - Then the block prints `merged this run: 2`
- [ ] AC-2: the block names a fix
  - Given the driver clears the ready file of a merged step
  - When the run ends
  - Then the block prints `driver fixes: 1` and a `fix:` line that holds the `Cleared:` text
- [ ] AC-3: nothing to list
  - Given the driver merges no step and makes no fix
  - When the run ends
  - Then the block prints `merged this run: none` and `driver fixes: 0`

## Dependencies
- `out()`, `main()`, and the final handlers in `initiative-run.mjs`.
