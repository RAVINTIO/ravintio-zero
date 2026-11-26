---
title: "Requirement: REQ-004 - Scratch goes under TMPDIR"
summary: "The implement skill and the testing standards tell the agent to put scratch under $TMPDIR and ban hard-coded /tmp paths."
status: "active"
version: "0.1.1"
---
# Requirement: REQ-004 - Scratch goes under TMPDIR

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000583-step-temp-cleanup-after-merge
**Source:** US-002
**Priority:** must-have

## User Story

As a step agent, I put scratch under `$TMPDIR`, so that it stays inside my worktree.

## Functional Requirements
- `testing-standards.md` holds rule `scratch-under-tmpdir`. It bans hard-coded `/tmp` paths and names the `EXIT` trap.
- The implement skill points to that rule.

## Acceptance Criteria
- [ ] AC-1: The rule exists
  - Given `testing-standards.md`
  - When the test reads rule `scratch-under-tmpdir`
  - Then it names `$TMPDIR`, `/tmp`, and `EXIT`
- [ ] AC-2: The skill points to it
  - Given the implement skill
  - When the test reads it
  - Then it names `scratch-under-tmpdir`

## Dependencies
- None.
