---
title: "Requirement: REQ-002 - hook commands use the project root"
summary: "hook commands use the project root."
status: "active"
version: "0.42.0"
---
# Requirement: REQ-002 - hook commands use the project root

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I start a session from a subfolder, so that every hook still finds its script.

## Functional Requirements

- Setup wires each Claude Code hook as `node "${CLAUDE_PROJECT_DIR}/.claude/hooks/enforcement/guard-run.mjs" {mode} {script}.mjs`, with mode `guard` or `advisory`.
- Setup wires the Codex `merge-guard` hook with the absolute project path.
- `setup.ps1` writes the same commands.
- A rerun replaces old relative commands and leaves one copy of each hook.

## Acceptance Criteria

- [ ] AC-1: commands independent of the working directory
  - Given setup ran
  - When each hook command in `.claude/settings.json` runs from a subfolder with `CLAUDE_PROJECT_DIR` set
  - Then the script runs and the exit code matches the script
- [ ] AC-2: Codex uses the absolute path
  - Given setup ran for Codex
  - When `.codex/hooks.json` is read
  - Then the command holds the absolute project path and no `git rev-parse`
- [ ] AC-3: old commands replaced
  - Given settings hold the old relative commands
  - When setup runs
  - Then each hook appears once, in the new form

## Dependencies

REQ-003
