---
title: "Requirement: req-004 - Strict mode and joining"
summary: "Flags decide strict mode, and a teammate who clones gets the guards after one documented step."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - Strict mode and joining

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-004
**Priority:** must-have

## User Story

As a teammate who clones, I get the guards after one documented step, and the flags decide strict mode.

## Functional Requirements

- A re-run with `--strict-orchestrator` keeps `plan/.orchestrator-strict`. A re-run with no strict flag keeps it too (initiative decision for 0000291).
- `--no-strict-orchestrator` removes `plan/.orchestrator-strict` and prints that it did. Passing both flags is an error.
- The getting-started guide has a "Joining a RAVINTIO repo" section that names the setup command.
- The session-start hook warns once when the repo has a pack but this clone has no hooks wired.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Strict mode follows the flags
  - Given strict mode is on
  - When setup re-runs with no flag, then with `--no-strict-orchestrator`
  - Then the sentinel survives the first run and goes after the second, with a printed line
- [ ] AC-2: Joining section
  - Given the getting-started guide
  - When a teammate reads it
  - Then it has a joining section that names the setup command
- [ ] AC-3: Warning on an unwired clone
  - Given a clone with a pack and no wired hooks
  - When a session starts
  - Then the hook prints one warning that names the setup command

## Dependencies

- None
