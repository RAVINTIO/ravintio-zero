---
title: "Requirement: REQ-001 - setup keeps Bash in the project root"
summary: "setup keeps Bash in the project root."
status: "active"
version: "0.42.0"
---
# Requirement: REQ-001 - setup keeps Bash in the project root

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Source:** US-001
**Priority:** must-have

## User Story

As a developer, I run any `cd` in a Bash command, so that later commands and hooks still run from the project root.

## Functional Requirements

- `setup.sh` and `setup.ps1` set `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` to `1` under `env` in `.claude/settings.json`, on every install and rerun.
- Setup keeps every other `env` entry and leaves one copy of the setting.

## Acceptance Criteria

- [ ] AC-1: setting written
  - Given a project with no `env` in `.claude/settings.json`
  - When setup runs
  - Then `env.CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` is `1`
- [ ] AC-2: other entries kept
  - Given `env` holds `FOO` set to `bar`
  - When setup runs
  - Then `FOO` is still `bar` and the setting is `1`
- [ ] AC-3: rerun is idempotent
  - Given setup ran once
  - When setup runs again
  - Then `.claude/settings.json` is byte for byte the same

## Dependencies

none
