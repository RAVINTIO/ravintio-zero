---
title: "Requirement: req-002 - Whole capability skill folders"
summary: "Setup copies every file of a capability skill folder."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Whole capability skill folders

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000381-setup-safety
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I keep a skill with `references/` in `ravintio-overrides/capability-skills/`, so that setup installs every file of it.

## Functional Requirements

- Setup copies each capability skill folder in full, with its subfolders.
- A folder with no `SKILL.md` prints the existing warning and installs nothing.
- `setup.sh` and `setup.ps1` install the same files.

## Acceptance Criteria

- [ ] AC-1: References installed
  - Given a capability skill with a `references/` file
  - When setup runs
  - Then the file exists under the skills directory
- [ ] AC-2: Missing SKILL.md warns
  - Given a folder with no `SKILL.md`
  - When setup runs
  - Then setup prints the warning and installs nothing from that folder
- [ ] AC-3: Shell parity
  - Given the same capability skill
  - When each script runs
  - Then both install the same file list

## Dependencies

- None
