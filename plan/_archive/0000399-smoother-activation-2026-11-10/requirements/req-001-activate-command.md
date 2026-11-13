---
title: "Requirement: REQ-001 - Activate command"
summary: "One script runs I-B Activate in order after one human confirmation."
status: "draft"
version: "0.1.0"
---
# Requirement: REQ-001 - Activate command

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000399-smoother-activation
**Source:** US-001
**Priority:** must-have

## User Story

As the human, I confirm once, so that the branch, activation PR, merge, and driver start run in order.

## Functional Requirements
- `initiative-activate.mjs` checks for an origin remote, `gh` access, no `initiative/{id}-*` branch on origin, and no other active initiative.
- It cuts and pushes the initiative branch. A feature branch writes `plan/current-initiative/initiative.md` with status `active` and deletes `plan/roadmap/{id}-{slug}/`.
- It opens the PR titled `{id}-{slug}: activate initiative`, waits with `gh pr checks --watch`, and merges with `gh pr merge --squash --delete-branch`.
- It prints `node ravintio-zero/scripts/initiative-run.mjs` and `node ravintio-zero/scripts/initiative-watch.mjs`.
- `--dry-run` prints the plan and changes nothing. A rerun after a stop resumes at the PR step.

## Acceptance Criteria
- [ ] AC-1: Activation runs in order
  - Given a charted draft and passing checks
  - When the human confirms once
  - Then the script merges the coordinator PR and prints the driver and watcher commands
- [ ] AC-2: A failed check blocks
  - Given a check fails, such as a missing origin remote
  - When the script runs
  - Then it prints `I-B Activate: Blocked: {reason}` and exits 1 before any change
- [ ] AC-3: Dry run changes nothing
  - Given a charted draft
  - When the script runs with `--dry-run`
  - Then it prints the plan and leaves the repo and remote unchanged

## Dependencies
- ADR-0296
