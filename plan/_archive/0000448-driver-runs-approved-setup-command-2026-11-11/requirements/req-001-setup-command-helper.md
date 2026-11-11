---
title: "Requirement: REQ-001 - Setup command helper"
summary: "setup-command.mjs reads the setup Confirmation row and returns the command only if it matches the allowed form."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Setup command helper

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000448-driver-runs-approved-setup-command
**Source:** US-001
**Priority:** must-have

## User Story

As a coordinator, I let the driver rerun the approved setup command at a `Setup:` stop, so that the run continues with no restart.

## Functional Requirements
- `setup-command.mjs` exports `findSetupCommand(text)`. It reads the `## Decisions` table of a chart.
- It looks at each row whose Fork starts with `Confirmation: setup`. It takes the first code span of the answer cell as the command.
- It returns `{ file, args }` if the command is the pack `setup.sh` path, `ravintio-zero/setup.sh` or `src/ravintio-zero/setup.sh`, followed by plain words and `--flag` words.
- It returns `null` if no row exists, if the command has any other form, or if two rows name different commands.
- The helper runs no command.

## Acceptance Criteria
- [ ] AC-1: valid row
  - Given a chart row `Confirmation: setup rerun` with the answer ``Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`.``
  - When `findSetupCommand` reads it
  - Then it returns the file `ravintio-zero/setup.sh` and the args `claude-code` and `--strict-orchestrator`
- [ ] AC-2: no row or a missing table
  - Given a chart with no `Confirmation:` row for setup
  - When `findSetupCommand` reads it
  - Then it returns `null`
- [ ] AC-3: a different form
  - Given a row whose command is `rm -rf x`, `bash -c y`, or `ravintio-zero/setup.sh a; b`
  - When `findSetupCommand` reads it
  - Then it returns `null`

## Dependencies
- none
