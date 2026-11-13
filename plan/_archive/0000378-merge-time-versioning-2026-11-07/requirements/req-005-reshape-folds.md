---
title: "Requirement: REQ-005 - Reshape folds admin commits"
summary: "A reshape folds the admin commits that a later step builds on, when the fold clears a conflict."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - Reshape folds admin commits

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Source:** US-005
**Priority:** should-have

## User Story

As a coordinator, I reshape a branch with admin commits that a later step builds on, so that delivery needs no human for a fold that clears the conflict.

## Functional Requirements

- On a replay conflict, the reshape retries with each earlier admin commit folded into the next step, as `--assign` does.
- It keeps a fold only if the replay is clean, the final tree equals the old head, and the history check passes. It prints each fold.
- It exits 1 and names the commit if no fold clears the conflict. It never drops or edits a hunk.
- I-E Delivery step 3 and the initiative skill describe the folds, and the delivery PR body names them.

## Acceptance Criteria

- [ ] AC-1: a fold clears the conflict
  - Given step 1 edits a file that the activation commit creates
  - When the reshape runs with no `--assign`
  - Then it succeeds and prints the fold
- [ ] AC-2: no fold clears it
  - Given a conflict between two steps
  - When the reshape runs
  - Then it exits 1 and names the commit
- [ ] AC-3: the tree is kept
  - Given any reshaped fixture
  - When the reshape ends
  - Then the final tree equals the old head

## Dependencies

- REQ-004
