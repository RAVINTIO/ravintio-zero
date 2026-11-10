---
title: "Requirement: REQ-002 - detach the queue worktree after every run"
summary: "The queue leaves its worktree on a detached HEAD after a successful run and after a failed run."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - detach the queue worktree after every run

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Source:** US-002
**Priority:** must-have

## User Story

As an initiative coordinator, I restart a step after a failed queue run, so that the step branch is free to check out.

## Functional Requirements
- After the queue switches to the PR branch, it detaches HEAD when `run` ends. This holds on success, on a stop, and on an unexpected error.
- The detach keeps HEAD at the commit it holds. It changes no file.
- If the detach fails, the queue ignores the failure and keeps the original result and exit code.

## Acceptance Criteria
- [ ] AC-1: failed run
  - Given a queue worktree and a run that stops on a red check
  - When the run ends
  - Then the worktree has no current branch, and another worktree can check out the PR branch
- [ ] AC-2: successful run
  - Given a queue worktree and a run that merges
  - When the run ends
  - Then the worktree has no current branch

## Dependencies
- none
