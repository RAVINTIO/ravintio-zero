---
title: "Requirement: REQ-001 - rerun fixture"
summary: "A second run on one PR adds no commit and still merges."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - rerun fixture

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I run the queue twice on one PR, so that I know the second run adds no commit and still merges.

## Functional Requirements
- A test file runs `merge-queue.mjs run` on one PR where the PR branch already holds the chart and version edits.
- The fixture reaches the rerun branch of `mergeAndRelease`, which skips the version and chart edits.

## Acceptance Criteria
- [ ] AC-1: no new commit
  - Given a PR branch that already holds the set-version commit for its step
  - When `run` runs again on that PR
  - Then the PR branch gains no commit
- [ ] AC-2: the second run merges
  - Given the same PR
  - When the second `run` finishes
  - Then it exits 0 and the base branch holds the squash merge and the version tag

## Dependencies
- none
