---
title: "Requirement: req-004 - PR title form"
summary: "PR title form."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - PR title form

**Skill:** [plan](../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000392-ship-postmortems
**Source:** US-004
**Priority:** must-have

## User Story

As a coordinator, I want P4 to raise a PR whose title passes `merge-queue.mjs title`, so that the queue does not stop on a title mismatch.

## Functional Requirements

- The ship skill writes the initiative step title as `{first 7 digits of the feature id}: {Title}`.
- Before `gh pr create`, ship runs `node ravintio-zero/scripts/merge-queue.mjs title --step {n} --title "{title}"` and fixes the title on a failure.

## Acceptance Criteria

- [ ] AC-1: Title form named
  - Given the ship skill
  - When a reader looks at Step 9
  - Then it names the seven-digit form and the `merge-queue.mjs title` command
- [ ] AC-2: Title passes the check
  - Given a chart row with feature id `0000392-ship-postmortems` and title `Ship postmortems`
  - When `merge-queue.mjs title` runs with `0000392: Ship postmortems`
  - Then the command prints `title ok`

## Dependencies

- None
