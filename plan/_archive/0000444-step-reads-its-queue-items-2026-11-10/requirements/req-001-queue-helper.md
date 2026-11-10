---
title: "Requirement: REQ-001 - queue helper"
summary: "initiative-queue.mjs lists the items that name a step and checks each for a commit or report."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - queue helper

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000444-step-reads-its-queue-items
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As a step session, I list the queue items that name my step, so that I never miss one.

## Functional Requirements
- `initiative-queue.mjs list --step {n}` prints one line per item whose `**Step:**` line holds `{n}`. The line holds the folder name and the destination.
- The helper reads `$RAVINTIO_INITIATIVE_ROOT/plan/.initiative-queue/`, or `plan/.initiative-queue/` under `--root` when the variable is unset.
- The helper reads item text as data and skips a symlinked folder or file. It warns on an item with no valid step line.
- `initiative-queue.mjs check --step {n} --base {ref}` exits 1 and names each named item that has no committed destination in `git diff {ref}...HEAD` and no `Queue item {name}:` line in `plan/current/build-log.md`.
- A destination with `{id}` matches seven digits in that position.

## Acceptance Criteria
- [ ] AC-1: list
  - Given a queue with items for steps 25 and 26
  - When the helper runs `list --step 26`
  - Then it prints only the step 26 items and exits 0
- [ ] AC-2: unsafe items
  - Given a symlinked item and an item with no step line
  - When the helper runs `list`
  - Then it skips both and exits 0
- [ ] AC-3: check
  - Given a named item with no commit and no report
  - When the helper runs `check`
  - Then it exits 1 and names the item, and a report line or a committed destination clears it

## Dependencies
- none
