---
title: "Requirement: REQ-001 - Refuse a linked style file"
summary: "Setup skips the Claude Code style install when the style path is a link."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Refuse a linked style file

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Source:** US-001
**Priority:** must-have

## User Story

As a repo owner, I run setup with a link at the style file path, so that setup skips the write. Setup prints a fixed line and exits 0.

## Functional Requirements
- `setup.sh` and `setup.ps1` check `.claude/output-styles/ravintio-writing.md` and its `output-styles` folder before the write.
- A link at either path, including a broken link, stops the style install and the `outputStyle` setting.
- Setup prints `  ! Refused: .claude/output-styles/ravintio-writing.md is a link, writing style not installed`.
- Setup exits 0 and leaves the link target unchanged.

## Acceptance Criteria
- [ ] AC-1: Linked style file
  - Given `.claude/output-styles/ravintio-writing.md` is a link to another file
  - When the human runs `setup.sh claude-code`
  - Then the target file keeps its bytes, the output holds the fixed line, and the exit status is 0
- [ ] AC-2: Linked style folder
  - Given `.claude/output-styles` is a link to another folder
  - When the human runs `setup.sh claude-code`
  - Then the other folder gains no file, the output holds the fixed line, and the exit status is 0
- [ ] AC-3: Plain path unchanged
  - Given no link sits at either path
  - When the human runs `setup.sh claude-code`
  - Then setup installs the style file as before

## Dependencies
- None
