---
title: "Requirement: REQ-001 - driver setup stop"
summary: "The driver stops after a merged step that changes installed pack files."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - driver setup stop

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000313-driver-setup-stop
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative owner, I want the driver to stop after a merged step that changes installed pack files, so that the next step runs on copies that match the pack.

## Functional Requirements

- The driver watches `ravintio-zero/skills/`, `ravintio-zero/hooks/`, `ravintio-zero/setup.sh`, and `ravintio-zero/setup/`.
- After a merged step changes a watched path, the driver prints `I-D Advance: Setup: step {n} changed {files}. Rerun setup, then start a new driver.`, releases the lock, and exits 1.
- If a step changes a `Restart:` file and a `Setup:` file, the driver prints one line that starts `I-D Advance: Restart: Setup:` and names each file once. The line ends `Rerun setup, then start a new driver so step {next} runs the new code.`
- The `Restart:` stop for a file that is not under a setup path keeps its current line.
- The file list names at most 5 files, then `and {k} more`.
- The check runs after the delivery, block, and not-merged checks. If git or the branch ref is unreadable, the driver skips it.

## Acceptance Criteria

- [ ] AC-1: skill change stops the driver
  - Given a two-step initiative and a step 1 that changes `ravintio-zero/skills/ravintio-ship/SKILL.md`
  - When the driver finishes step 1
  - Then it prints a `Setup:` line that names the file, releases the lock, exits 1, and starts no step 2
- [ ] AC-2: a test-only change gives no stop
  - Given a step that changes only a file under `ravintio-zero/tests/`
  - When the driver finishes the step
  - Then it prints no `Setup:` line and starts the next step
- [ ] AC-3: both stops give one line
  - Given a step that changes `ravintio-zero/scripts/initiative-run.mjs` and `ravintio-zero/hooks/x.sh`
  - When the driver finishes the step
  - Then it prints one line that starts `I-D Advance: Restart: Setup:` and names both files

## Dependencies

- None
