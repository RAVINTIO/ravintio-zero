---
title: "Requirement: REQ-001 - Run every hook"
summary: "The script runs each hook in .claude/settings.json with CLAUDE_PROJECT_DIR set and one fixed sample input."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Run every hook

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000507-hook-check-after-setup
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator, I run one command after setup, so that I know every installed hook loads and runs.

## Functional Requirements
- `hook-check.mjs` reads every hook command in `.claude/settings.json` of the project root.
- The script runs each command with `CLAUDE_PROJECT_DIR` set to the project root.
- The script feeds each command one fixed JSON sample on stdin, chosen by hook event and matcher.
- The script runs each hook with its working directory set to a temporary directory, so a sample changes nothing in the repo.
- A settings file that is missing or not valid JSON makes the script exit 2 with one stderr line.

## Acceptance Criteria
- [ ] AC-1: all hooks run
  - Given a project whose `.claude/settings.json` lists three hook commands
  - When the script runs
  - Then the script starts each of the three commands once with `CLAUDE_PROJECT_DIR` set
- [ ] AC-2: sample per event and matcher
  - Given hooks for `PreToolUse` with matcher `Write` and for `Stop` with matcher `.*`
  - When the script runs
  - Then each hook receives the fixed sample for its own event and matcher
- [ ] AC-3: bad settings file
  - Given a `.claude/settings.json` that is not valid JSON
  - When the script runs
  - Then the script exits 2 and prints one stderr line that names the file

## Dependencies
- None.
