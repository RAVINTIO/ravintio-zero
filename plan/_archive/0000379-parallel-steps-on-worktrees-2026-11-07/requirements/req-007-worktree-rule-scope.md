---
title: "Requirement: REQ-007 - Worktree rule scope"
summary: "Worktree rule scope"
status: "active"
version: "0.1.0"
---
# Requirement: REQ-007 - Worktree rule scope

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000379-parallel-steps-on-worktrees
**Source:** US-006
**Priority:** must-have

## User Story

As a human, I keep working on a `feat/` branch in the main tree, while the driver may use worktrees.

## Functional Requirements

- `standard-boot.md` and `codex-boot.md` tell a human session to work on a `feat/` branch in the main working tree. They allow the driver to run steps in worktrees under `plan/.initiative-worktrees/`.
- The repo override `custom-001-local-git-only.md` carries the same scoped rule, so setup regenerates this repo's `CLAUDE.md` with it.

## Acceptance Criteria

- [ ] AC-1: the boot templates scope the rule
  - Given the boot templates
  - When a test reads them
  - Then each says a human session works in the main tree and the driver may use worktrees
- [ ] AC-2: the override matches
  - Given `custom-001-local-git-only.md`
  - When a test reads it
  - Then it no longer says "Don't use git worktrees" without a human-session scope

## Dependencies

- none
