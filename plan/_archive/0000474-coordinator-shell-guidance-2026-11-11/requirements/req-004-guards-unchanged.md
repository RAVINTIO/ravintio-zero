---
title: "Requirement: REQ-004 - Guards stay strict"
summary: "A test pins that merge-guard and block-forced-add still block variable, compound, and quoted commands."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - Guards stay strict

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I read one section on shell use, so that zsh and guard snags stop costing time.

## Functional Requirements
- A test feeds `merge-guard` and `block-forced-add` commands that hold a variable, a compound form, and a quoted flag.
- The test expects the same exit codes the guards give before this change.
- The change edits neither hook file.

## Acceptance Criteria
- [ ] AC-1: Forced add forms stay blocked
  - Given `block-forced-add`
  - When it reads a compound command and a quoted `-f` flag
  - Then it exits 2
- [ ] AC-2: Merge forms stay blocked
  - Given `merge-guard` with a stub `gh` that reports an `initiative/x` base
  - When it reads `gh pr merge $N --squash` and a compound merge command
  - Then it exits 2
- [ ] AC-3: Hooks untouched
  - Given the diff of this feature
  - When it lists the files under `hooks/enforcement/`
  - Then neither guard file appears

## Dependencies
- None
