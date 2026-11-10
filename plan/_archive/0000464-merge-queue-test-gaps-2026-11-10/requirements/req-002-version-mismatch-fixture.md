---
title: "Requirement: REQ-002 - version mismatch fixture"
summary: "A set that leaves one version file different makes run exit 1 before the merge."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - version mismatch fixture

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000464-merge-queue-test-gaps
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I stub a version file that stays different, so that I know `run` exits 1 before the merge.

## Functional Requirements
- A test file builds a world where `setVersions` writes every file but one version file reads back different.
- The fixture reaches the post-set `cmdVersions` check in `mergeAndRelease`.

## Acceptance Criteria
- [ ] AC-1: run stops
  - Given a version file that reads back a different version after the set
  - When `run` runs on the PR
  - Then it exits 1 and the output names the file and both versions
- [ ] AC-2: no merge
  - Given the same run
  - When it stops
  - Then the PR stays open and the base branch holds no new tag

## Dependencies
- none
