---
title: "Requirement: REQ-002 - Refuse a linked AGENTS.md writing block"
summary: "Setup skips the Codex writing block when AGENTS.md is a link."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Refuse a linked AGENTS.md writing block

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000551-refuse-symlink-style-outputs
**Source:** US-001
**Priority:** must-have

## User Story

As a repo owner, I run setup with a link at `AGENTS.md`, so that setup skips the writing block. Setup prints a fixed line and exits 0.

## Functional Requirements
- `setup.sh` and `setup.ps1` check `AGENTS.md` before the writing block write.
- A link at `AGENTS.md`, including a broken link, skips the block.
- Setup prints `  ! Refused: AGENTS.md is a link, writing section not installed`.
- Setup exits 0 and the writing block never reaches the link target.
- The boot file write stays as it is.

## Acceptance Criteria
- [ ] AC-1: Linked AGENTS.md
  - Given `AGENTS.md` is a link to another file
  - When the human runs `setup.sh codex`
  - Then the target holds no writing block, the output holds the fixed line, and the exit status is 0
- [ ] AC-2: Plain file unchanged
  - Given `AGENTS.md` is a plain file
  - When the human runs `setup.sh codex`
  - Then the file holds one writing block as before

## Dependencies
- None
