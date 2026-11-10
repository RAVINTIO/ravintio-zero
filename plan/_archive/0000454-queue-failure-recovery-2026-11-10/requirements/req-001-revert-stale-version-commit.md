---
title: "Requirement: REQ-001 - revert a stale version commit"
summary: "A rerun reverts an earlier set-version commit when the base version moved, so the base merge has no conflict."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - revert a stale version commit

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000454-queue-failure-recovery
**Source:** US-001
**Priority:** must-have

## User Story

As an initiative coordinator, I rerun a failed queue run, so that the version rows no longer conflict with the base branch.

## Functional Requirements
- The queue reads the next version from the base branch before it merges the base into the PR branch.
- The queue lists the commits on the PR branch that the base lacks. It selects those whose subject is `chore({id7}): set version {v} for step {n}` for this step.
- If a selected commit holds a version other than the next version, the queue reverts all selected commits, newest first, in one commit. It then merges the base.
- If every selected commit holds the next version, the queue reverts nothing.
- A revert that conflicts stops the queue with the git error and leaves the branch as it was.
- The revert commit subject is `chore({id7}): revert set version {v} for step {n}`. The queue pushes it without force.

## Acceptance Criteria
- [ ] AC-1: stale version commit
  - Given a PR branch with a set-version commit and a base whose version moved on
  - When the queue reruns the PR
  - Then the queue merges the base with no conflict, sets the new version, and merges the PR
- [ ] AC-2: unchanged base
  - Given a PR branch with a set-version commit for the version the base would give now
  - When the queue reruns the PR
  - Then the queue adds no commit to the branch and still merges the PR
- [ ] AC-3: no force-push
  - Given a rerun that reverts a stale commit
  - When the queue pushes
  - Then the remote branch only gains commits and every earlier commit stays

## Dependencies
- none
