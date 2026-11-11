---
title: "Requirement: REQ-003 - Ship commits filed entries"
summary: "The ship skill and the roadmap standards state the rule, and a step commits each entry it filed."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - Ship commits filed entries

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000497-keep-worktree-entries
**Source:** US-003
**Priority:** must-have

## User Story

As a step session, I commit each backlog entry I file before the PR, so that the squash carries it.

## Functional Requirements
- Ship Step 4 tells the step to list untracked files under `plan/backlog/` with `git status --porcelain`.
- The step stages each entry it filed by explicit path and commits it. It never stages an entry it did not write.
- The driver header comment and `roadmap-standards.md` state that the driver keeps a worktree that holds untracked backlog entries.
- ADR-0325 records the decision, and `docs/decisions-index.md` lists it.

## Acceptance Criteria
- [ ] AC-1: ship rule
  - Given the ship skill
  - When a reader opens Step 4
  - Then it names `plan/backlog/` and explicit-path staging of filed entries
- [ ] AC-2: driver rule in the docs
  - Given the driver header and `roadmap-standards.md`
  - When a reader searches for `untracked backlog entries`
  - Then both files state the rule

## Dependencies
- REQ-001.
