---
title: "Requirement: req-002 - Clean-tree check"
summary: "Setup installs only committed pack and override files."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - Clean-tree check

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000382-install-lifecycle
**Source:** US-002
**Priority:** must-have

## User Story

As a developer, I want setup to install only committed pack files, so that no unreviewed edit reaches `.claude/`.

## Functional Requirements

- Before setup copies anything, it runs `git status --porcelain` on `ravintio-zero/` and `ravintio-overrides/`.
- If either folder holds a modified, staged, or untracked file, setup lists each file, copies nothing, and exits non-zero.
- Setup skips files that git ignores.
- Setup has no bypass flag. Setup outside a git repo exits non-zero with a clear message.
- `setup.sh` and `setup.ps1` behave the same.

## Acceptance Criteria

- [ ] AC-1: Modified pack file blocks setup
  - Given an uncommitted change in `ravintio-zero/`
  - When setup runs
  - Then it exits non-zero, names the file, and `.claude/` is unchanged
- [ ] AC-2: Untracked override blocks, ignored file does not
  - Given an untracked file in `ravintio-overrides/` and an ignored file in `ravintio-zero/`
  - When setup runs
  - Then the untracked file blocks setup and the ignored file does not
- [ ] AC-3: Outside git
  - Given a folder that is not a git repo
  - When setup runs
  - Then it exits non-zero with a message that names git

## Dependencies

- None
