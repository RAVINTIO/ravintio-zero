---
title: "Requirement: REQ-002 - Queue drain"
summary: "A drain subcommand removes the queue items that name a merged step."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Queue drain

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000474-coordinator-shell-guidance
**Source:** US-002
**Priority:** must-have

## User Story

As the coordinator, I run scripts for repeated tasks, so that I never improvise a compound command.

## Functional Requirements
- `node ravintio-zero/scripts/initiative-queue.mjs drain --step {n} [--root dir]` removes each queue folder whose `item.md` holds `**Step:** {n}`.
- It prints `drained: {folder}` for each folder it removes.
- It skips a symlinked folder or file, and a folder whose name fails the `NAME` pattern. It prints a warning for each skip.
- It leaves items that name other steps.
- With no matching item, it prints `drained: none` and exits 0.
- A missing or invalid `--step` exits 2 with one line on stderr.

## Acceptance Criteria
- [ ] AC-1: Matching items go
  - Given a queue with two items for step 7 and one for step 8
  - When `drain --step 7` runs
  - Then it prints a `drained:` line for each step 7 folder and leaves the step 8 folder
- [ ] AC-2: Unsafe entries stay
  - Given a symlinked item folder that names step 7
  - When `drain --step 7` runs
  - Then it removes nothing there and prints a warning
- [ ] AC-3: Empty queue
  - Given no item names step 7
  - When `drain --step 7` runs
  - Then it prints `drained: none` and exits 0

## Dependencies
- `initiative-queue.mjs` (`namedItems`)
