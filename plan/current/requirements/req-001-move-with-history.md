---
title: "Requirement: REQ-001 - Move with history"
summary: "Rename the pack source with no content edit."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Move with history

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000397-pack-source-in-src
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I find the pack source at `src/ravintio-zero/` with `git log --follow` history, so that blame survives the move.

## Functional Requirements
- One commit holds `git mv ravintio-zero src/ravintio-zero` and no content edit.
- `git diff -M --stat` for that commit shows renames only.

## Acceptance Criteria
- [ ] AC-1: History follows
  - Given the move commit
  - When you run `git log --follow src/ravintio-zero/setup.sh`
  - Then the log lists commits from before the move
- [ ] AC-2: Pure rename
  - Given the move commit
  - When you run `git diff -M --numstat HEAD~1 HEAD`
  - Then every row shows 0 added and 0 removed lines

## Dependencies
- None.
