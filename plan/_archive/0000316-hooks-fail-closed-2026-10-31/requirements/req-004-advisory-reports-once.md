---
title: "Requirement: REQ-004 - advisory hooks report a missing script once"
summary: "advisory hooks report a missing script once."
status: "active"
version: "0.42.0"
---
# Requirement: REQ-004 - advisory hooks report a missing script once

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want an advisory hook with a missing script to say so once, so that the loss is visible and the session is not blocked.

## Functional Requirements

- `guard-run.mjs advisory {script}` runs the script and passes its exit code and output through.
- If the script is missing, the launcher exits 0 and prints one line to stderr that names the script. It prints the line once per script and project, and records that in a file under the OS temp folder.

## Acceptance Criteria

- [ ] AC-1: missing script reported
  - Given the script file does not exist
  - When the launcher runs in advisory mode
  - Then it exits 0 and stderr names the script
- [ ] AC-2: reported once
  - Given the launcher already reported the script
  - When it runs again
  - Then stderr stays empty and the exit code is 0
- [ ] AC-3: output passes through
  - Given a script that prints context to stdout and exits 0
  - When the launcher runs in advisory mode
  - Then stdout is unchanged

## Dependencies

REQ-003
