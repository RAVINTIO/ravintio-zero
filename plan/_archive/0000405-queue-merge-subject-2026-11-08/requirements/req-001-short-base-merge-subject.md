---
title: "Requirement: REQ-001 - short base-merge subject"
summary: "The merge queue's base merge commit uses a short subject that the commit-msg hook accepts."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - short base-merge subject

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000405-queue-merge-subject
**Source:** US-001
**Priority:** must-have

## User Story

As the coordinator of an initiative, I see the queue merge the initiative branch into a ready PR with a subject the `commit-msg` hook accepts, so that steps merge with no manual repair.

## Functional Requirements
- `cmdRun` in `ravintio-zero/scripts/merge-queue.mjs` passes `-m "{id}: Merge the initiative branch"` to the base merge. The id is the first 7 digits of the step's `Feature id`.
- The queue never passes `--no-verify`.
- A conflict still aborts the merge and stops the queue, as before.

## Acceptance Criteria
- [ ] AC-1: the base merge has the short subject
  - Given a ready PR behind the initiative branch
  - When the queue runs for that step
  - Then the merge commit on the PR branch has the subject `0000401: Merge the initiative branch`
- [ ] AC-2: a blocking hook passes
  - Given a `commit-msg` hook that rejects subjects over 72 characters
  - And a step branch name that makes git's default subject longer than 72
  - When the queue runs for that step
  - Then it merges the base, and the step PR merges
- [ ] AC-3: the existing suites pass
  - Given the 0000378 and 0000379 queue suites
  - When they run
  - Then each one exits 0

## Dependencies
- none
