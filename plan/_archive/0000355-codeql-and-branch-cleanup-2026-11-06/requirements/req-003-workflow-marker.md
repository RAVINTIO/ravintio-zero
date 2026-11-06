---
title: "Requirement: REQ-003 - workflow job marker"
summary: "The shape test reads a marker comment and the plan scan names the workflow cause."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - workflow job marker

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000355-codeql-and-branch-cleanup
**Source:** US-003
**Priority:** must-have

## User Story

As a pack maintainer, I add a CI job with a marker comment and edit no test, so that a new job does not fail the suite.

## Functional Requirements
- `test-0000169-req-006` skips the pull request guard check for a job whose key line follows the comment `# ravintio:job-guard-exempt`, and for no other job.
- The fixed name list in that test is gone. The marker sits on `release-tag`, `main-merge-check`, `initiative-history`, `squash-before-main`, and `cleanup-branch` in both workflow files.
- The plan skill's test impact scan has a cause: the run adds or edits a job or step in a workflow file. It greps `ravintio-zero/tests/` for `ravintio.yml`.
- The scan stays at 15 lines or fewer.

## Acceptance Criteria
- [ ] AC-1: marked job passes
  - Given a new job with the marker comment and no guard
  - When the shape test runs
  - Then it passes with no edit to the test
- [ ] AC-2: unmarked job still checked
  - Given a new job with no marker and no guard
  - When the shape test runs
  - Then it fails
- [ ] AC-3: scan names the cause
  - Given the plan skill
  - When a test reads the scan
  - Then it names the workflow cause and `ravintio.yml`

## Dependencies
- REQ-004 adds the `cleanup-branch` job that carries a marker.
