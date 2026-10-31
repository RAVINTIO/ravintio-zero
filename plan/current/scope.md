---
title: "Scope - hooks fail closed"
summary: "Boundaries for the hook wiring work."
status: "active"
version: "0.42.0"
---
# Scope - hooks fail closed

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Version:** 0.42.0

## In Scope

- `setup.sh` and `setup.ps1` write `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` under `env` and keep other `env` entries.
- Claude Code hook commands use `${CLAUDE_PROJECT_DIR}`. Codex hook commands use the absolute project path.
- `guard-run.mjs` launches the four guards and the four advisory hooks.
- Tests and docs for each change.

## Out of Scope

- Changes to what any guard blocks.
- Detecting a launcher that is itself missing.
- New guards and other tools.

## Deferred

- Nothing deferred.
