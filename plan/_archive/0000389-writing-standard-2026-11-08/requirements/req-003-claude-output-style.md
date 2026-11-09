---
title: "Requirement: req-003 - Claude Code output style"
summary: "Claude Code output style."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - Claude Code output style

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000389-writing-standard
**Source:** US-003
**Priority:** must-have

## User Story

As a Claude Code user, I get an output style generated from the standard, so that the main session follows it.

## Functional Requirements

- `ravintio-zero/scripts/writing-style.mjs claude-code` prints an output style file: frontmatter with `name: ravintio-writing`, a description, and `keep-coding-instructions: true`, then the `style-rules` region.
- `setup.sh` and `setup.ps1` write that output to `.claude/output-styles/ravintio-writing.md` for the `claude-code` tool.
- Setup sets `outputStyle` to `ravintio-writing` in `.claude/settings.json` when the key is absent, through the existing atomic settings writer.
- If `outputStyle` holds another value, setup leaves it and prints that it did.
- A second run changes no file.

## Acceptance Criteria

- [ ] AC-1: Install writes style and setting
  - Given a repo with no `.claude/settings.json`
  - When setup runs for `claude-code`
  - Then `.claude/output-styles/ravintio-writing.md` exists and `outputStyle` is `ravintio-writing`
- [ ] AC-2: Existing style stays
  - Given `.claude/settings.json` with `outputStyle` set to `Concise`
  - When setup runs for `claude-code`
  - Then `outputStyle` is still `Concise` and setup prints that it left the value
- [ ] AC-3: No drift, no churn
  - Given a finished install
  - When setup runs again and a test regenerates the style from the standard
  - Then the installed file matches the regeneration and no file changes
