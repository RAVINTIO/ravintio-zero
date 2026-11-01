---
title: "Requirement: REQ-003 - the runner fails when the tree changes"
summary: "the runner fails when the tree changes."
status: "active"
version: "0.41.2"
---
# Requirement: REQ-003 - the runner fails when the tree changes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000315-isolated-test-state
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I want the runner to fail when a run changes the tree, so that a test never leaves repo state behind.

## Functional Requirements

- `run-tests.sh` snapshots tracked and untracked files before the first suite and after the last.
- If the snapshots differ, the runner prints each changed path and exits 1.
- The check reads tracked and untracked files only.
- Outside a git repository, the check is skipped.
- `run-tests.ps1` runs the same check.

## Acceptance Criteria

- [ ] AC-1: a changed file fails the run
  - Given a suite that creates an untracked file
  - When the runner finishes
  - Then it names the file and exits 1
- [ ] AC-2: an ignored file is allowed
  - Given a suite that writes an ignored file
  - When the runner finishes
  - Then the check passes
- [ ] AC-3: a changed tracked file fails the run
  - Given a suite that edits a tracked file
  - When the runner finishes
  - Then it names the file and exits 1

## Dependencies

none
