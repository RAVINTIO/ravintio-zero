---
title: "Requirement: REQ-002 - Step PR title check"
summary: "A step PR title must match the chart row before the squash."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - Step PR title check

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000378-merge-time-versioning
**Source:** US-002
**Priority:** must-have

## User Story

As a coordinator, I check a step PR title against the chart before the merge, so that the squash commit matches the history check.

## Functional Requirements

- `merge-queue.mjs title --step {n} --title {text}` compares the text with `{first 7 digits of Feature id}: {Title}` from the chart row for step `n`.
- It compares strings and builds no regular expression from the title.
- It exits 1 and prints the expected title on a mismatch, and exits 0 on a match.
- I-D Advance runs it before `gh pr merge --squash`.

## Acceptance Criteria

- [ ] AC-1: matching title passes
  - Given a chart row `0000378-merge-time-versioning` titled `Merge-time versioning`
  - When the title is `0000378: Merge-time versioning`
  - Then the command exits 0
- [ ] AC-2: slug in the title fails
  - Given the same chart row
  - When the title is `0000378-merge-time-versioning: Merge-time versioning`
  - Then the command exits 1 and prints `0000378: Merge-time versioning`

## Dependencies

- None
