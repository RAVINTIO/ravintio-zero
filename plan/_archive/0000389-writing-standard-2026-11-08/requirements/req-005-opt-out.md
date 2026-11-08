---
title: "Requirement: req-005 - Opt out"
summary: "Opt out."
status: "active"
version: "0.1.0"
---
# Requirement: req-005 - Opt out

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-005
**Priority:** must-have

## User Story

As a developer with my own style, I can skip the install, so that Zero never overrides my choice.

## Functional Requirements

- `--no-writing-style` is a valid flag in `setup.sh` and `setup.ps1`, and the usage text lists it.
- With the flag, setup writes no output style file, sets no `outputStyle`, and adds no Codex section.
- The setup record in `plan/state/{tool}.md` and the flags marker record the flag. `ravintio-refresh-setup` accepts it as an allowed flag and passes it on a refresh.

## Acceptance Criteria

- [ ] AC-1: Flag skips both outputs
  - Given a repo
  - When setup runs with `--no-writing-style` for `claude-code` or `codex`
  - Then no output style file, no `outputStyle` key, and no `AGENTS.md` writing section appear
- [ ] AC-2: Refresh keeps the flag
  - Given a setup record that lists `--no-writing-style`
  - When `ravintio-refresh-setup` reads the record
  - Then it accepts the flag and includes it in the command
