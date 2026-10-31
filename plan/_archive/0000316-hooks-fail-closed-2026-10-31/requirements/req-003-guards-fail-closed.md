---
title: "Requirement: REQ-003 - a guard that cannot run blocks"
summary: "a guard that cannot run blocks."
status: "active"
version: "0.42.0"
---
# Requirement: REQ-003 - a guard that cannot run blocks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000316-hooks-fail-closed
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I want a guard whose script is missing or crashes to block and name the script, so that the guard never silently allows.

## Functional Requirements

- `guard-run.mjs guard {script}` resolves the script beside itself and runs it with the same stdin.
- Exit 0 and exit 2 pass through, with stdout and stderr unchanged.
- A missing script, a spawn error, a signal, or any other exit code makes the launcher exit 2 and print one line to stderr that names the script.
- Every case that `gate-write`, `ratchet-check`, `em-dash-guard`, and `merge-guard` block today stays blocked.

## Acceptance Criteria

- [ ] AC-1: missing script blocks
  - Given the script file does not exist
  - When the launcher runs in guard mode
  - Then it exits 2 and stderr names the script
- [ ] AC-2: crash blocks
  - Given a script that exits 1
  - When the launcher runs in guard mode
  - Then it exits 2 and stderr names the script and the code
- [ ] AC-3: blocks and passes survive
  - Given a script that exits 2 with a reason, and one that exits 0
  - When the launcher runs each
  - Then the exit codes and the reason pass through

## Dependencies

none
