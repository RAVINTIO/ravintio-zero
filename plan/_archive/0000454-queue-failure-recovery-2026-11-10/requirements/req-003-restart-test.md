---
title: "Requirement: REQ-003 - restart test"
summary: "One suite runs a failed queue run, a base change, a restart, and a rerun, and checks both recoveries."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - restart test

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Source:** US-003
**Priority:** must-have

## User Story

As a maintainer, I run the restart path in a test, so that a regression in either fix fails CI.

## Functional Requirements
- The suite builds a bare remote, a clone, a queue worktree, an initiative branch with a chart, and two step branches.
- A fake `gh` fails the PR checks only after the PR head holds a set-version commit.
- The suite fails the first run, merges the second step, then reruns the first step.
- The suite also checks the queue worktree after each run, and the remote history of the step branch.

## Acceptance Criteria
- [ ] AC-1: failure and restart path
  - Given a first run that fails after its version push and a second step that merges after it
  - When the first step reruns
  - Then the rerun merges, tags the new version, and leaves the queue worktree detached
- [ ] AC-2: branch ownership
  - Given a failed run in a queue worktree
  - When another worktree checks out the PR branch
  - Then the checkout succeeds
- [ ] AC-3: unchanged base
  - Given a failed run and no change on the base
  - When the step reruns
  - Then the rerun adds no commit before the merge

## Dependencies
- REQ-001, REQ-002
