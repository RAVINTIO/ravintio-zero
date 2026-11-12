---
title: "Requirement: REQ-002 - Judge each result"
summary: "A hook passes on exit 0 or a deliberate guard block. Any other result is a failure the script names."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-002 - Judge each result

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I read one verdict per hook, so that I see which hook fails and why.

## Functional Requirements
- A hook that exits 0 passes.
- A hook that exits 2 passes, because a guard's deliberate block is correct behaviour.
- A hook that exits with any other code, fails to spawn, or exceeds the time limit fails.
- The script prints one line per hook with the verdict, the event, the matcher, and the script name.
- The script exits 0 if every hook passes and 1 if any hook fails.

## Acceptance Criteria
- [ ] AC-1: deliberate block passes
  - Given a guard hook that exits 2 on its sample
  - When the script runs
  - Then the script reports a pass for that hook
- [ ] AC-2: load failure fails
  - Given a hook command that names a missing script
  - When the script runs
  - Then the script names that hook as failed and exits 1
- [ ] AC-3: other exit code fails
  - Given a hook that exits 1
  - When the script runs
  - Then the script reports a failure for that hook

## Dependencies
- REQ-001
