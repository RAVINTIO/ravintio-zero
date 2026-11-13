---
title: "Requirement: REQ-001 - Ready file helper"
summary: "A helper checks the PR number and writes or checks the ready file."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Ready file helper

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000442-ready-file-helper
**Source:** US-001
**Priority:** must-have

## User Story

As a step session, I run one command that writes a checked ready file. Then the driver never meets an invalid file.

## Functional Requirements
- `node ravintio-zero/scripts/initiative-ready.mjs --pr {n}` writes `{n}` and a newline to `$RAVINTIO_INITIATIVE_CONTROL/ready` and prints `I-D Advance: Ready: PR #{n}`.
- `--check` reads the file and exits 0 only when it holds a PR number.
- The number must match `^[1-9][0-9]{0,6}$`, the pattern the driver uses.
- The helper refuses a symlink at the control folder or at the file.
- The helper writes through a temporary file and a rename, with mode 600.

## Acceptance Criteria
- [ ] AC-1: Write a valid number
  - Given `RAVINTIO_INITIATIVE_CONTROL` names an existing folder
  - When the step runs the helper with `--pr 42`
  - Then `ready` holds `42` and a newline, and the helper prints `I-D Advance: Ready: PR #42`
- [ ] AC-2: Refuse bad input
  - Given a value such as `4x`, `0`, an empty string, or a timestamp, or no control variable, or a symlinked folder or file
  - When the step runs the helper
  - Then the helper exits 1, names the reason, and writes nothing
- [ ] AC-3: Check the file
  - Given a `ready` file that holds `42`, is empty, or is missing
  - When the step runs the helper with `--check`
  - Then it exits 0 for `42` and exits 1 for the other two

## Dependencies
- None.

## Input Validation

- [ ] Input source: the `--pr` argument, the `RAVINTIO_INITIATIVE_CONTROL` variable, and the `ready` file
- [ ] Allowed character pattern: `[0-9]` for the number, all other values refused
- [ ] maximum length: 7 characters for the number
- [ ] Failure behaviour: exit 1 with one line on stderr and no write
- [ ] Logging policy: the refusal line names the reason and never echoes the raw value
