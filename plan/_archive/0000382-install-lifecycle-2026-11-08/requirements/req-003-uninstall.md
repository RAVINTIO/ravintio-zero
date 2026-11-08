---
title: "Requirement: req-003 - Uninstall"
summary: "One command reverses setup and keeps the developer's work."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Uninstall

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-003
**Priority:** must-have

## User Story

As a developer, I remove Zero's setup changes with one command and keep my own work.

## Functional Requirements

- `setup.sh claude-code --uninstall` unsets `core.hooksPath`, removes the RAVINTIO hook entries from `.claude/settings.json`, and removes the files in the manifests, the workflow, and `.gitattributes` when setup wrote them.
- It keeps the developer's own `settings.json` entries and files.
- It deletes no record under `plan/` and lists the records. It removes the two marker files `plan/.orchestrator-strict` and `plan/.orchestrator-ack`, because they belong to the guards it removes.
- It removes a skill only when the manifest lists it and the pack or `ravintio-overrides/capability-skills/` names it, so a skill the developer placed in the skills folder survives.
- It prints each guard it removes and refuses while `plan/.orchestrator-active` or `plan/.initiative-runner.lock` exists.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Setup changes reversed
  - Given an installed repo with a developer's own `settings.json` entry
  - When the developer runs uninstall
  - Then `core.hooksPath` is unset, no RAVINTIO hook remains, and the own entry survives
- [ ] AC-2: Plan untouched
  - Given `plan/` records
  - When the developer runs uninstall
  - Then no record under `plan/` is deleted and the output lists the records
- [ ] AC-3: Refuses during a run
  - Given `plan/.orchestrator-active` exists
  - When the developer runs uninstall
  - Then it exits non-zero and changes nothing

## Dependencies

- None
