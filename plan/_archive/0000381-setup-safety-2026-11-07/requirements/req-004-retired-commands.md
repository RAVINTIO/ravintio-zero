---
title: "Requirement: req-004 - Prune retired commands"
summary: "Setup removes retired pack commands and keeps developer commands."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - Prune retired commands

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Source:** US-004
**Priority:** must-have

## User Story

As a developer, I re-run setup, so that `.claude/commands/` holds only pack commands and my own.

## Functional Requirements

- Setup records each command it installs in `.claude/commands/.ravintio-manifest`. On a re-run it removes a listed file that the pack no longer ships.
- Setup also removes `fast-path.md`, `change-pipeline.md`, and `retrofit.md` when the file's `name:` line matches. This covers installs that predate the manifest.
- Migration 0008 and its helpers apply the same removal outside a setup run.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Retired commands gone
  - Given an install with the three retired commands
  - When setup runs
  - Then none of the three exists
- [ ] AC-2: Own command survives
  - Given a developer command file in `.claude/commands/`
  - When setup re-runs
  - Then the file is unchanged
- [ ] AC-3: Migration removes them
  - Given the same install
  - When the migration helper runs
  - Then the three files are gone and a second run changes nothing

## Dependencies

- None
