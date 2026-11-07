---
title: "Requirement: REQ-002 - own-path commits"
summary: "The dispatch standard tells each unit to commit with its own paths and bans amend in a batch."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - own-path commits

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000359-safe-parallel-commits
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I find the dispatch standard tells each unit to run `git commit -m "{message}" -- {paths}` and bans `git commit --amend` in a batch, so that a unit's commit holds only its own paths.

## Functional Requirements
- `## Fast batches` of `agent-dispatch-standards.md` tells each unit to commit with `git commit -m "{message}" -- {paths}`, so the commit takes only those paths even when another unit has staged files.
- The same section forbids `git commit --amend` in a batch. A unit that needs a fix makes a new commit.
- The existing stage-by-path and no-stash bullets stay.

## Acceptance Criteria
- [ ] AC-1: path-limited commit form
  - Given the Fast batches section
  - When a test reads it
  - Then it names `git commit -m "{message}" -- {paths}`
- [ ] AC-2: amend ban
  - Given the Fast batches section
  - When a test reads it
  - Then it forbids `git commit --amend`
- [ ] AC-3: earlier rules stay
  - Given the Fast batches section
  - When a test reads it
  - Then it still names `git add -A` and `git stash`

## Dependencies
- None.
