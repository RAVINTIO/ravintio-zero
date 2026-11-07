---
title: "Requirement: REQ-001 - fail closed with no launcher"
summary: "A guard hook command exits 2 when guard-run.mjs is missing, and setup.ps1 writes the same command."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - fail closed with no launcher

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000357-guard-gaps-closed
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I find that a guard hook blocks the call when `guard-run.mjs` is missing, so that no file removal turns every guard off.

## Functional Requirements
- Each guard-mode hook command that `setup.sh` and `setup.ps1` write for Claude Code ends with ` || exit 2`. The guards are `gate-write`, `ratchet-check`, `em-dash-guard`, `merge-guard`, and `block-forced-add`.
- The Codex hook commands end the same way.
- An advisory hook command stays as it is, because exit 2 on a Stop or UserPromptSubmit hook blocks the session.
- The command prefix `node "${CLAUDE_PROJECT_DIR}/{dir}/guard-run.mjs" guard {module}.mjs` is unchanged, so the hook filters still match.

## Acceptance Criteria
- [ ] AC-1: missing launcher blocks
  - Given a guard hook command from the settings setup writes and no `guard-run.mjs` on disk
  - When `sh` runs the command with `CLAUDE_PROJECT_DIR` set
  - Then it exits 2
- [ ] AC-2: launcher result passes through
  - Given the launcher is present and the hook script allows the call
  - When `sh` runs the command
  - Then it exits 0
- [ ] AC-3: both setup scripts agree
  - Given `setup.sh` and `setup.ps1`
  - When a test reads the command each writes for a guard module
  - Then both end with ` || exit 2` and neither adds it to an advisory command

## Dependencies
- None.
